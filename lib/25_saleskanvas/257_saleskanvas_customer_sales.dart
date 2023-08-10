import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

import '257_saleskanvas_customer_update.dart';

class SalesKanvasCustomerSalesPage extends StatefulWidget {
  final cCustomer;
  SalesKanvasCustomerSalesPage({this.cCustomer});

  @override
  _SalesKanvasCustomerSalesState createState() =>
      _SalesKanvasCustomerSalesState();
}

class _SalesKanvasCustomerSalesState
    extends State<SalesKanvasCustomerSalesPage> {
  String cLanguage = '';
  String cServerFile = '';
  String _entryTrnDate = '';
  String _cTrnDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  DateTime dateTimeNow = DateTime.now();

  double nQty = 0;
  double nAmount = 0;

  bool isLoading = true;
  bool isFirst = true;

  List dataJSON = [];
  List dataItems = [];

  @override
  void initState() {
    super.initState();
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
        title: Text("Sales"),
        backgroundColor: rx_function.RexColors.AppBar,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[900],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SalesKanvasCustomerUpdatePage('', '', '', _entryTrnDate),
            ),
          ).whenComplete(() => _initCheck());
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: rx_function.RexColors.BackGround,
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cardQty(context),
                      _cardAmount(context),
                      _cardBlank(context),
                    ],
                  ),
                  Divider(),
                  _widgetSearch(
                    var1: 'code',
                    var2: 'name',
                    var3: '',
                  ),
                  Divider(),
                  dataItems.length < 1
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              rx_function.getText('Data Not Found !!!'),
                              style: TextStyle(
                                fontSize: 18,
                                color: rx_function.RexColors.AppBar,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: dataItems.length,
                            itemBuilder: (BuildContext context, int index) =>
                                buildListView(context, index),
                          ),
                        ),
                  SizedBox(height: 200),
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

  Widget _cardQty(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 80,
        child: GestureDetector(
          onTap: () => {},
          child: Card(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    rx_function.getText('Qty'),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    NumberFormat('#,##0').format(nQty),
                    style: TextStyle(
                        fontSize: 18,
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

  Widget _cardAmount(BuildContext context) {
    return Expanded(
      flex: 5,
      child: SizedBox(
        height: 80,
        child: GestureDetector(
          onTap: () => {},
          child: Card(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    rx_function.getText('Amount'),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    NumberFormat('#,##0').format(nAmount),
                    style: TextStyle(
                        fontSize: 18,
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

  Widget _cardBlank(BuildContext context) {
    return Expanded(
      flex: 5,
      child: SizedBox(
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              child: ElevatedButton(
                onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => SalesKanvasTransactionPage()),
//                ).whenComplete(() => _initCheck());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: rx_customs.RexColors.ButtonApprove,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => ProjectSiteFuelUpdatePage(
//                dataItems[index]['id'],
//                dataItems[index],
//                widget.cProject,
//                _entryTrnDate),
//          ),
//        ).whenComplete(() => _initCheck());
      },
      child: Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataItems[index]['code'] ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        rx_function.getText('Qty') +
                            ' : ' +
                            NumberFormat('#,##0')
                                .format(double.parse(dataItems[index]['qty'])),
                        style: new TextStyle(
                            fontSize: 16.0, color: Colors.blue[900]),
                      ),
                      Text(
                        rx_function.getText('Price') +
                            ' : ' +
                            NumberFormat('#,##0').format(
                                double.parse(dataItems[index]['price'])),
                        style: new TextStyle(
                            fontSize: 16.0, color: Colors.blue[900]),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(' '),
                          Spacer(),
                          Text(
                            NumberFormat('#,##0').format(
                                double.parse(dataItems[index]['amount'])),
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.blue[900]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 10,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black38,
                    size: 35.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);
    int nRow = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cDeviceID = prefs.getString('device_id').toString();
    String cRestapiSalesKanvas =
        prefs.getString('server_restapi').toString() + 'restapi_sales_kanvas/';

    var response = await http.post(
        Uri.parse(cRestapiSalesKanvas +
            'get_kanvas_trnsales' +
            '?db=' +
            cCompanyCode +
            '&computer_id=' +
            cDeviceID),
        headers: {"Accept": "'application/json"});

    nQty = 0;
    nAmount = 0;
    dataItems.clear();
    setState(() {
      if (response.statusCode == 200) {
        dataJSON = jsonDecode(response.body);

        dataJSON.forEach((element) {
          nQty = nQty + double.parse(dataJSON[nRow]['qty']);
          nAmount = nAmount + double.parse(dataJSON[nRow]['amount']);
          nRow++;
        });
        dataItems.addAll(dataJSON);
      }
      isLoading = false;
    });
  }
}
