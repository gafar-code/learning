import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;

class ListingHeaderPage extends StatefulWidget {
  @override
  _ListingHeaderState createState() => _ListingHeaderState();
}

class _ListingHeaderState extends State<ListingHeaderPage> {
  String _cTrnDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  double nSummary = 0;
  bool isLoading = true;

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
        title: Text("101. Listing Header"),
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
                  SizedBox(height: 50),
                  dataItems.length < 1
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              'Data Not Found',
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
                            itemCount: dataItems.length + 1,
                            itemBuilder: (BuildContext context, int index) =>
                                index == dataItems.length
                                    ? buildListViewTotal(context, index)
                                    : buildListView(context, index),
                          ),
                        ),
                  SizedBox(height: 200),
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
//            builder: (context) => HrdAttendanceDeviceDetailPage(
//                cCode: dataItems[index]['device'], cTrnDate: widget.cTrnDate),
//          ),
//        );
      },
      child: Container(
        child: Card(
          elevation: 3,
          child: Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 5 / 10,
                  color: Colors.green[200],
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dataItems[index]['device'] != null
                              ? dataItems[index]['device']
                              : '',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 3 / 10,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          NumberFormat('#,##0')
                              .format(double.parse(dataItems[index]['amount'])),
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.blue[900]),
                        ),
                      ],
                    ),
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
          ),
        ),
      ),
    );
  }

  Widget buildListViewTotal(BuildContext context, int index) {
    return Container(
      child: Card(
        elevation: 3,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 5 / 10,
                color: Colors.green[500],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'TOTAL',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 3 / 10,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        NumberFormat('#,##0').format(nSummary),
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1 / 10,
                child: Text(''),
              ),
            ],
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
    String cRestapiAttendance =
        prefs.getString('server_restapi').toString() + 'restapi_attendance/';

    var response = await http.post(
        Uri.parse(cRestapiAttendance +
            'get_trnfingerprint_device' +
            '?db=' +
            cCompanyCode +
            '&trndate=' +
            _cTrnDate +
            '&location_code=' +
            'ALL'),
        headers: {"Accept": "'application/json"});

    nSummary = 0;
    dataItems.clear();

    setState(
      () {
        if (response.statusCode == 200) {
          dataJSON = jsonDecode(response.body);
          dataItems.addAll(dataJSON);

          dataItems.forEach(
            (data) {
              nSummary = nSummary + double.parse(dataItems[nRow]['amount']);
              nRow++;
            },
          );
        }

        isLoading = false;
      },
    );
  }
}
