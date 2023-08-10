import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

class SalesKanvasCustomerInfoPage extends StatefulWidget {
  final cCustomer;
  SalesKanvasCustomerInfoPage({this.cCustomer});

  @override
  _SalesKanvasCustomerInfoState createState() =>
      _SalesKanvasCustomerInfoState();
}

class _SalesKanvasCustomerInfoState extends State<SalesKanvasCustomerInfoPage> {
  List dataJSON = [];
  List dataItems = [];
  List dataEquipment = [];
  List dataProduction = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Info"),
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
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      _listProfile1(),
                      SizedBox(height: 10),
                      _listProfile2(),
                      SizedBox(height: 10),
                      _listProfile3(),
                      SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _listProfile1() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          _buildHeader('Customer'),
          _buildDivider(),
          _buildList('Name', dataItems[0]['name'], false),
          _buildList('Code', dataItems[0]['code'], false),
          _buildList('Address', dataItems[0]['address'], false),
          _buildList('City', dataItems[0]['city'], false),
        ],
      ),
    );
  }

  Widget _listProfile2() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(children: <Widget>[
        _buildHeader('Receivable'),
        _buildDivider(),
/*        ListView.builder(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: dataEquipment.length,
          itemBuilder: (BuildContext context, int index) => Container(
            child: Card(
              color: Colors.blueGrey[50],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dataEquipment[index]['equipment_name'] != null
                          ? dataEquipment[index]['equipment_name']
                          : '',
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                    Text(
                      dataEquipment[index]['equipment_code'] != null
                          ? dataEquipment[index]['equipment_code']
                          : '',
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
*/
      ]),
    );
  }

  Widget _listProfile3() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(children: <Widget>[
        _buildHeader('Transaction'),
        _buildDivider(),
        ListView.builder(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: dataProduction.length,
          itemBuilder: (BuildContext context, int index) => Container(
            child: Card(
              color: Colors.blueGrey[50],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dataProduction[index]['job_name'] != null
                          ? dataProduction[index]['job_name'] +
                              '  [' +
                              dataProduction[index]['job_code'] +
                              ']'
                          : '',
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          dataProduction[index]['contract_qty'] != null
                              ? 'Contract Titik : ' +
                                  NumberFormat('#,##0').format(double.parse(
                                      dataProduction[index]['contract_qty']))
                              : '',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        Text(
                          dataProduction[index]['contract_amount'] != null
                              ? 'm2 : ' +
                                  NumberFormat('#,##0').format(double.parse(
                                      dataProduction[index]['contract_amount']))
                              : '',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          dataProduction[index]['qty_titik'] != null
                              ? 'Production Titik : ' +
                                  NumberFormat('#,##0').format(double.parse(
                                      dataProduction[index]['qty_titik']))
                              : '',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        Text(
                          dataProduction[index]['qty_m2'] != null
                              ? 'm2 : ' +
                                  NumberFormat('#,##0').format(double.parse(
                                      dataProduction[index]['qty_m2']))
                              : '',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cRestapiSalesKanvas =
        prefs.getString('server_restapi').toString() + 'restapi_sales_kanvas/';

    var response1 = await http.post(
        Uri.parse(cRestapiSalesKanvas +
            'get_customer' +
            '?db=' +
            cCompanyCode +
            '&customer_code=' +
            widget.cCustomer),
        headers: {"Accept": "'application/json"});

    dataItems.clear();
    setState(() {
      if (response1.statusCode == 200) {
        dataJSON = jsonDecode(response1.body);
        dataItems.addAll(dataJSON);
      }
    });

    var response2 = await http.post(
        Uri.parse(cRestapiSalesKanvas +
            'get_project_equipment' +
            '?db=' +
            cCompanyCode +
            '&project_code=' +
            widget.cCustomer),
        headers: {"Accept": "'application/json"});

    dataEquipment.clear();
    setState(() {
      if (response2.statusCode == 200) {
        dataJSON = jsonDecode(response2.body);
        dataEquipment.addAll(dataJSON);
      }
    });

    var response3 = await http.post(
        Uri.parse(cRestapiSalesKanvas +
            'get_project_production_summary' +
            '?db=' +
            cCompanyCode +
            '&project_code=' +
            widget.cCustomer),
        headers: {"Accept": "'application/json"});

    dataProduction.clear();
    setState(() {
      if (response3.statusCode == 200) {
        dataJSON = jsonDecode(response3.body);
        dataProduction.addAll(dataJSON);
      }
    });

    setState(() => isLoading = false);
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      width: double.infinity,
      height: 3.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildHeader(cHeader) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(height: 10, width: 20),
          Container(
            child: Text(
              cHeader,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildList(cHeader, cName, isChange) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  rx_function.getText(cHeader),
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
//                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  cName != null ? cName : '.',
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            width: double.infinity,
            height: 1.0,
            color: Colors.grey.shade200,
          )
        ],
      ),
    );
  }
}
