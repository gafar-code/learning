import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;

class ListingEmployeePage extends StatefulWidget {
  @override
  _ListingEmployeeState createState() => _ListingEmployeeState();
}

class _ListingEmployeeState extends State<ListingEmployeePage> {
  TextEditingController _entrySearch = new TextEditingController();
  String cServerFile = '';

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
        title: Text('103. Listing Employee'),
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
                  _widgetButtonSearch(),
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
                          : Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: dataItems.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        buildListView(context, index),
                              ),
                            ),
                  SizedBox(height: 200),
                ],
              ),
      ),
    );
  }

  Widget _widgetButtonSearch() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(20.0),
            child: TextField(
              controller: _entrySearch,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  hintText: 'Search .....',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none),
            ),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () => _initCheck(),
            style: ElevatedButton.styleFrom(
                primary: Colors.teal[600],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Text("Search"),
          ),
        )
      ],
    );
  }

  Widget buildListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => HrdProfileDetailPage(
//                  cCode: dataItems[index]['code'],
//                  cEmployeeID: dataItems[index]['id'])),
//        );
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
                        width: MediaQuery.of(context).size.width / 4,
                        fit: BoxFit.cover,
                        useOldImageOnUrlChange: true,
                        imageUrl: dataItems[index]['image_name'] != ''
                            ? cServerFile +
                                'employee/' +
                                dataItems[index]['image_name']
                            : cServerFile + 'noImage.png',
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dataItems[index]['name'] != null
                            ? dataItems[index]['name']
                            : '',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      Text(
                        dataItems[index]['code'] != null
                            ? '[' + dataItems[index]['code'] + ']'
                            : '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(),
                      Text(
                        dataItems[index]['position_code'] != null
                            ? dataItems[index]['position_code']
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        dataItems[index]['location_code'] != null
                            ? dataItems[index]['location_code']
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        dataItems[index]['division_code'] != null
                            ? dataItems[index]['division_code']
                            : '',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cRestapiEmployee =
        prefs.getString('server_restapi').toString() + 'restapi_employee/';
    cServerFile = prefs.getString('server_file').toString();

    dataItems.clear();
    if (_entrySearch.text != '') {
      var response = await http.get(
          Uri.parse(cRestapiEmployee +
              'get_employee_search' +
              '?db=' +
              cCompanyCode +
              '&search=' +
              _entrySearch.text.toLowerCase()),
          headers: {"Accept": "'application/json"});

      setState(
        () {
          if (response.statusCode == 200) {
            dataJSON = jsonDecode(response.body);
            dataItems.addAll(dataJSON);
          }
        },
      );
    }
    setState(() => isLoading = false);
  }
}
