import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

import '257_saleskanvas_transaction.dart';

class SalesKanvasCustomerPage extends StatefulWidget {
  @override
  _SalesKanvasCustomerState createState() => _SalesKanvasCustomerState();
}

class _SalesKanvasCustomerState extends State<SalesKanvasCustomerPage> {
  String _entryRoute = '______';

  String cPostalCode = '';

  bool isLoading = true;

  List dataJSON = [];
  List dataItems = [];
  List dataRoute = [];

  @override
  void initState() {
    super.initState();
    _initRoute();
    _initCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanvas Customer'),
        backgroundColor: rx_customs.RexColors.BarColor,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: rx_customs.RexColors.BackGround,
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardRoute(context),
                _cardBlank(context),
              ],
            ),
            Divider(),
            _widgetSearch(var1: 'code', var2: 'name', var3: ''),
            Divider(),
            isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : dataItems.length < 1
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Text(
                            'Data Not Found',
                            style: TextStyle(
                              fontSize: 17,
                              color: rx_function.RexColors.AppBar,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: dataItems.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildListView(context, index),
                        ),
                      ),
            Divider(),
            _cardRetail(),
          ],
        ),
      ),
    );
  }

  Widget _widgetSearch({var1, var2, var3}) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(20.0),
      child: TextField(
        onChanged: (value) {
          value = value.toLowerCase();
          setState(() {
            dataItems = dataJSON.where((widget) {
              var name = (var1 != '' ? widget[var1].toLowerCase() : '') +
                  (var2 != '' ? widget[var2].toLowerCase() : '') +
                  (var3 != '' ? widget[var3].toLowerCase() : '');
              return name.contains(value);
            }).toList();
          });
        },
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            hintText: 'Search .....',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none),
      ),
    );
  }

  Widget buildListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => AssetMoveAddNewPage(
//                      cRoom: dataItems[index]['room_code'],
//                      cCode: dataItems[index]['asset_id'],
//                      cQty: NumberFormat('#,##0')
//                          .format(double.parse(dataItems[index]['qty'])),
//                    ))).whenComplete(() => _initCheck());
      },
      child: Container(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dataItems[index]['asset_name'] != null
                            ? dataItems[index]['asset_name']
                            : '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        dataItems[index]['asset_code'] != null
                            ? dataItems[index]['asset_code']
                            : '',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Text(
                        dataItems[index]['room_code'] != null
                            ? dataItems[index]['room_code']
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        dataItems[index]['qty'] != null
                            ? 'qty : ' +
                                NumberFormat('#,##0').format(
                                    double.parse(dataItems[index]['qty']))
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        dataItems[index]['buydate'] != null
                            ? 'date : ' + dataItems[index]['buydate']
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        dataItems[index]['descr01'] != null
                            ? dataItems[index]['descr01']
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 35.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardRoute(BuildContext context) {
    return Expanded(
      flex: 6,
      child: SizedBox(
        height: 80,
        child: GestureDetector(
          onTap: () => _showRouteDialog(),
          child: Card(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 70 / 100,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Route",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    _entryRoute,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: rx_function.RexColors.AppBar),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRouteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Route"),
          content: Container(
            height: 300,
            width: double.minPositive,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dataRoute.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    setState(
                      () {
                        _entryRoute = dataRoute[i]['code'];
                      },
                    );
                    _initRoute();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text(
                      dataRoute[i]['code'],
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _cardBlank(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 80,
      ),
    );
  }

  Widget _cardRetail() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(''),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 10.0),
            child: ElevatedButton(
              onPressed: () {
                _clickRetail(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesKanvasTransactionPage()),
                ).whenComplete(() => _initCheck());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: rx_customs.RexColors.ButtonSave,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'New Customer',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cRestapiMobApp =
        prefs.getString('server_restapi').toString() + 'restapi_mobapp/';

    var response = await http.get(
        Uri.parse(cRestapiMobApp +
            'get_listing_room' +
            '?db=' +
            cCompanyCode +
            '&room_code=' +
            '' +
            '&building_code=' +
            _entryRoute),
        headers: {"Accept": "'application/json"});

    dataItems.clear();
    setState(
      () {
        if (response.statusCode == 200) {
          dataJSON = jsonDecode(response.body);
          dataItems.addAll(dataJSON);
        }
        isLoading = false;
      },
    );
  }

  Future _initRoute() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cEmployeeCode = prefs.getString('employee_code').toString();
    String cRestapiMobApp =
        prefs.getString('server_restapi').toString() + 'restapi_mobapp/';

    var responseBuilding = await http.post(
        Uri.parse(cRestapiMobApp +
            'get_building_user' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    setState(() {
      if (responseBuilding.statusCode == 200) {
        dataRoute = jsonDecode(responseBuilding.body);
      }
      isLoading = false;
    });
  }

  _clickRetail(context) async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: CircularProgressIndicator(),
        ),
      ),
    );

    await Geolocator.requestPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      try {
        List<Placemark> newPlace = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark placeMark = newPlace[0];
        cPostalCode = placeMark.postalCode.toString();
      } catch (e) {
        cPostalCode = '000000';
      }
    } catch (e) {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cEmployeeCode = prefs.getString('employee_code').toString();
    String cRestapiSalesKanvas =
        prefs.getString('server_restapi').toString() + 'restapi_sales_kanvas/';

    var response = await http.post(
        Uri.parse(cRestapiSalesKanvas +
            'save_customer_retail' +
            '?db=' +
            cCompanyCode +
            '&customer_code=' +
            cPostalCode),
        headers: {"Accept": "'application/json"});

    if (response.statusCode == 200) {}

    prefs.setString('temp_customer', cPostalCode);
    prefs.setString('temp_groupprice', 'RETAIL');
  }

  Widget _buildHeader(cHeader) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(height: 10, width: 10),
          Container(
            child: Text(
              cHeader,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
