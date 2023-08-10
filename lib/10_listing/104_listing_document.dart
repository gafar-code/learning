import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
//import '952_personal_document_add.dart';
//import '952_personal_document_edit.dart';
//import '../00_standard/25_display_image.dart';

class ListingDocumentPage extends StatefulWidget {
  @override
  _ListingDocumentState createState() => _ListingDocumentState();
}

class _ListingDocumentState extends State<ListingDocumentPage> {
  String cServerFile = '';

  List dataJSON = [];
  List dataJSON2 = [];

  List itemActive = [];
  List itemNotActive = [];
  bool isLoading = true;

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("104. Listing Document"),
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
          bottom: new TabBar(tabs: <Widget>[
            Tab(
              text: "Active",
            ),
            Tab(
              text: "Not Active",
            )
          ]),
        ),
        backgroundColor: rx_function.RexColors.BackGround,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 25.0, right: 10.0),
          child: FloatingActionButton(
            backgroundColor: Colors.lightBlue[900],
            onPressed: () {
//              Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => PersonalDocumentAddPage()))
//                  .whenComplete(() => _initCheck());
            },
            child: Icon(Icons.add),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: itemActive.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildListView(context, index),
                  ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: itemNotActive.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildListView2(context, index),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildListView(BuildContext context, int index) {
    var item = itemActive[index];
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => PersonalDocumentEditPage(
//              builder: (context) => DisplayImagePage(
//                  cImage: cServerFile + 'employee/' + item['image_name'])),
//        ).whenComplete(() => _initCheck());
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
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                        useOldImageOnUrlChange: true,
                        imageUrl:
                            cServerFile + 'employee/' + item['image_name'],
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) {
                          return Image(
                            image: AssetImage('assets/noImage.png'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        item['document_code'] == null
                            ? ''
                            : item['document_code'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item['descr'] == null ? '' : item['descr'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(),
                      Text(
                        item['create_by'] != null
                            ? item['create_by'] + '\n' + item['create_date']
                            : '',
                        style: TextStyle(color: Colors.teal[800], fontSize: 12),
                      ),
                      Divider(),
                      item['status'] == '7'
                          ? OutlinedButton(
                              child: Text('Approved'),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.green[700],
                              ),
                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          PersonalDocumentEditPage(
//                                              cDataID: item['id'],
//                                              cStatus: '8')),
//                                ).whenComplete(() => _initCheck());
                              },
                            )
                          : OutlinedButton(
                              child: Text('Waiting'),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.orange[400],
                              ),
                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          PersonalDocumentEditPage(
//                                              cDataID: item['id'],
//                                              cStatus: '8')),
//                                ).whenComplete(() => _initCheck());
                              },
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
          ),
        ),
      ),
    );
  }

  Widget buildListView2(BuildContext context, int index) {
    var item = itemNotActive[index];
    return GestureDetector(
      child: Container(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                        useOldImageOnUrlChange: true,
                        imageUrl:
                            cServerFile + 'employee/' + item['image_name'],
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) {
                          return Image(
                            image: AssetImage('assets/noImage.png'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        item['document_code'] == null
                            ? ''
                            : item['document_code'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item['descr'] == null ? '' : item['descr'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(),
                      Text(
                        item['create_by'] != null
                            ? item['create_by'] + '\n' + item['create_date']
                            : '',
                        style: TextStyle(color: Colors.teal[800], fontSize: 12),
                      ),
                      Divider(),
                      item['status'] == '8'
                          ? OutlinedButton(
                              child: Text('Not Active'),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.red[700],
                              ),
                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          PersonalDocumentEditPage(
//                                              cDataID: item['id'],
//                                              cStatus: '7')),
//                                ).whenComplete(() => _initCheck());
                              },
                            )
                          : OutlinedButton(
                              child: Text('Waiting'),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.orange[400],
                              ),
                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          PersonalDocumentEditPage(
//                                              cDataID: item['id'],
//                                              cStatus: '7')),
//                                ).whenComplete(() => _initCheck());
                              },
                            ),
                    ],
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cEmployeeCode = prefs.getString('employee_code').toString();
    String cRestapiEmployee =
        prefs.getString('server_restapi').toString() + 'restapi_employee/';
    cServerFile = prefs.getString('server_file').toString();

    var response = await http.get(
        Uri.parse(cRestapiEmployee +
            'get_employee_documentactive' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    itemActive.clear();
    if (response.statusCode == 200) {
      setState(
        () {
          dataJSON = jsonDecode(response.body);

          itemActive.addAll(dataJSON);
        },
      );
    }

    var response2 = await http.get(
        Uri.parse(cRestapiEmployee +
            'get_employee_documentnotactive' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    itemNotActive.clear();
    if (response2.statusCode == 200) {
      setState(
        () {
          dataJSON2 = jsonDecode(response2.body);

          itemNotActive.addAll(dataJSON2);
        },
      );
    }

    setState(() => isLoading = false);
  }
}
