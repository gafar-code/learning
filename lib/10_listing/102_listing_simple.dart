import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_standard/12_language.dart';

class ListingSimplePage extends StatefulWidget {
  final dateTimeFrom, dateTimeTo, cCompany, cHeader;

  ListingSimplePage(
      {this.dateTimeFrom, this.dateTimeTo, this.cCompany, this.cHeader});

  @override
  _ListingSimplePageState createState() => _ListingSimplePageState();
}

class _ListingSimplePageState extends State<ListingSimplePage> {
  String cLanguage = '';
  String cFromPeriod = '';
  String cToPeriod = '';

  List dataJSON = [];
  List dataTemp = [];
  List dataItems = [];

  bool isLoading = false;
  bool descendingOrder = false;

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
        title: Text("102. Listing Simple"),
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
                  _widgetSearch(
                    var1: 'customer_name',
                    var2: 'customer_code',
                    var3: '',
                  ),
                  Divider(),
                  _widgetSorting(),
                  Divider(),
                  dataItems.length < 1
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              setLanguage('Data Not Found !!!', cLanguage),
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

  Widget _widgetSorting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              primary: Colors.grey[400],
            ),
            onPressed: () {
              setState(
                () {
                  dataItems.sort((a, b) =>
                      a['customer_name'].compareTo(b['customer_name']));
                },
              );
            },
            child: Text('Sort Name'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              primary: Colors.grey[400],
            ),
            onPressed: () {
              if (descendingOrder == false) {
                setState(
                  () {
                    dataItems.sort((b, a) => double.parse(a['amount'])
                        .compareTo(double.parse(b['amount'])));
                  },
                );
                descendingOrder = true;
              } else if (descendingOrder == true) {
                setState(
                  () {
                    dataItems.sort((a, b) => double.parse(a['amount'])
                        .compareTo(double.parse(b['amount'])));
                  },
                );
                descendingOrder = false;
              }
            },
            child: Text('Sort Amount'),
          ),
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => SalesOmzetCustomerDetailPage(
//                      code: dataItems[index].cItemCode,
//                      fromperiod: cFromPeriod,
//                      toperiod: cToPeriod,
//                    ),
//                  ),
//                );
      },
      child: Container(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dataItems[index]['customer_name'] != null
                                ? dataItems[index]['customer_name'] +
                                    '   [' +
                                    dataItems[index]['customer_code'] +
                                    ']'
                                : '',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            dataItems[index]['customer_city'] != null
                                ? dataItems[index]['customer_city']
                                : '',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1 / 10,
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.black38,
                        size: 35.0,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      NumberFormat('#,##0')
                          .format(double.parse(dataItems[index]['amount'])),
                      style: new TextStyle(
                          fontSize: 20.0, color: Colors.blue[900]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cRestapiSales =
        prefs.getString('server_restapi').toString() + 'restapi_sales/';

    cFromPeriod = widget.dateTimeFrom.substring(4, 8);
    if (widget.dateTimeFrom.substring(0, 3) == 'Jan')
      cFromPeriod = cFromPeriod + '01';
    if (widget.dateTimeFrom.substring(0, 3) == 'Feb')
      cFromPeriod = cFromPeriod + '02';
    if (widget.dateTimeFrom.substring(0, 3) == 'Mar')
      cFromPeriod = cFromPeriod + '03';
    if (widget.dateTimeFrom.substring(0, 3) == 'Apr')
      cFromPeriod = cFromPeriod + '04';
    if (widget.dateTimeFrom.substring(0, 3) == 'May')
      cFromPeriod = cFromPeriod + '05';
    if (widget.dateTimeFrom.substring(0, 3) == 'Jun')
      cFromPeriod = cFromPeriod + '06';
    if (widget.dateTimeFrom.substring(0, 3) == 'Jul')
      cFromPeriod = cFromPeriod + '07';
    if (widget.dateTimeFrom.substring(0, 3) == 'Aug')
      cFromPeriod = cFromPeriod + '08';
    if (widget.dateTimeFrom.substring(0, 3) == 'Sep')
      cFromPeriod = cFromPeriod + '09';
    if (widget.dateTimeFrom.substring(0, 3) == 'Oct')
      cFromPeriod = cFromPeriod + '10';
    if (widget.dateTimeFrom.substring(0, 3) == 'Nov')
      cFromPeriod = cFromPeriod + '11';
    if (widget.dateTimeFrom.substring(0, 3) == 'Dec')
      cFromPeriod = cFromPeriod + '12';

    cToPeriod = widget.dateTimeTo.substring(4, 8);
    if (widget.dateTimeTo.substring(0, 3) == 'Jan')
      cToPeriod = cToPeriod + '01';
    if (widget.dateTimeTo.substring(0, 3) == 'Feb')
      cToPeriod = cToPeriod + '02';
    if (widget.dateTimeTo.substring(0, 3) == 'Mar')
      cToPeriod = cToPeriod + '03';
    if (widget.dateTimeTo.substring(0, 3) == 'Apr')
      cToPeriod = cToPeriod + '04';
    if (widget.dateTimeTo.substring(0, 3) == 'May')
      cToPeriod = cToPeriod + '05';
    if (widget.dateTimeTo.substring(0, 3) == 'Jun')
      cToPeriod = cToPeriod + '06';
    if (widget.dateTimeTo.substring(0, 3) == 'Jul')
      cToPeriod = cToPeriod + '07';
    if (widget.dateTimeTo.substring(0, 3) == 'Aug')
      cToPeriod = cToPeriod + '08';
    if (widget.dateTimeTo.substring(0, 3) == 'Sep')
      cToPeriod = cToPeriod + '09';
    if (widget.dateTimeTo.substring(0, 3) == 'Oct')
      cToPeriod = cToPeriod + '10';
    if (widget.dateTimeTo.substring(0, 3) == 'Nov')
      cToPeriod = cToPeriod + '11';
    if (widget.dateTimeTo.substring(0, 3) == 'Dec')
      cToPeriod = cToPeriod + '12';

    var response = await http.post(
        Uri.parse(cRestapiSales +
            'get_customer' +
            '?db=' +
            cCompanyCode +
            '&unitcompany=' +
            'ALL' +
            '&fromperiod=' +
            cFromPeriod +
            '&toperiod=' +
            cToPeriod),
        headers: {"Accept": "'application/json"});

    dataItems.clear();
    setState(() {
      dataJSON = jsonDecode(response.body);
      dataItems.addAll(dataJSON);
    });

    setState(() => isLoading = false);
  }
}
