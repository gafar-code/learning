import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../10_home.dart';
import '../00_standard/12_language.dart';
import '../00_standard/12_function.dart' as rx_function;

class Map_LinePage extends StatefulWidget {
  @override
  _Map_LinePageState createState() => _Map_LinePageState();
}

class _Map_LinePageState extends State<Map_LinePage> {
  String cLanguage = '';

  bool isLoading = false;

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
        title: Text('Map Marker'),
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
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => EntrySimpleUpdatePage('', ''),
//            ),
//          ).whenComplete(() => _initCheck());
        },
        child: Icon(Icons.arrow_circle_right),
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

  Widget buildListView(BuildContext context, int index) {
    return Container(
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
                      dataItems[index]['code'] != null
                          ? dataItems[index]['code']
                          : '',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      dataItems[index]['name'] != null
                          ? dataItems[index]['name']
                          : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      dataItems[index]['gps_latitude'] != null
                          ? dataItems[index]['gps_latitude']
                          : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      dataItems[index]['gps_longitude'] != null
                          ? dataItems[index]['gps_longitude']
                          : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    cLanguage = prefs.getString('userlanguage').toString();

    var response = await http.get(
        Uri.parse(cRestapiSales +
            'get_master_customer_listing' +
            '?db=' +
            cCompanyCode),
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
}
