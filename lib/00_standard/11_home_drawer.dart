import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '11_home_about.dart';
import '../00_standard/12_function.dart';
import '../17_login.dart';
import '../10_listing/10_listing.dart';
import '../30_entry/30_entry.dart';
import '../01_riset/01_riset.dart';
import '../40_map/40_map.dart';
import '../25_saleskanvas/25_saleskanvas.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String cUserName = '';

  String cCompanyCode = '';
  String cEmployeeImage = '';
  String cEmployeeName = '';
  String cEmployeePosition = '';

  List dataJSON = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(cEmployeeName,
                style: TextStyle(color: Colors.white, fontSize: 15.0)),
            accountEmail: Text(cEmployeePosition,
                style: TextStyle(color: Colors.white, fontSize: 12.0)),
            currentAccountPicture: cEmployeeImage != ""
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).canvasColor,
                    backgroundImage: CachedNetworkImageProvider(cEmployeeImage),
                  )
                : CircularProgressIndicator(),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: dataJSON.length,
              itemBuilder: (BuildContext context, int index) {
                if (dataJSON[index]['mainmenu_code'] == 'F10') {
                  return new CustomListTile(
                    Icons.corporate_fare_rounded,
                    'Listing',
                    () => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPage()))
                    },
                  );
                }
                if (dataJSON[index]['mainmenu_code'] == 'F12') {
                  return new CustomListTile(
                    Icons.corporate_fare_rounded,
                    'Profile',
                    () => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingPage()))
                    },
                  );
                }

                if (dataJSON[index]['mainmenu_code'] == 'F15') {
                  return new CustomListTile(
                    Icons.corporate_fare_rounded,
                    'Entry',
                    () => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => EntryPage()))
                    },
                  );
                }

                if (dataJSON[index]['mainmenu_code'] == 'F20') {
                  return new CustomListTile(
                    Icons.corporate_fare_rounded,
                    'Map',
                    () => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MapPage()))
                    },
                  );
                }

                if (dataJSON[index]['mainmenu_code'] == 'F21') {
                  return new CustomListTile(
                    Icons.corporate_fare_rounded,
                    'Riset',
                    () => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => RisetPage()))
                    },
                  );
                }

                if (dataJSON[index]['mainmenu_code'] == 'F25') {
                  return new CustomListTile(
                    Icons.corporate_fare_rounded,
                    'Riset',
                    () => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesKanvasPage()))
                    },
                  );
                }

                return new CustomListTile(
                    Icons.notifications, 'Logout', () => {_logoutPage});
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    String cRestapiUserName = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(
      () {
        cCompanyCode = prefs.getString('company_code').toString();
        cUserName = prefs.getString('username').toString();
        cEmployeeName = prefs.getString('employee_name').toString();
        cEmployeeImage = prefs.getString('employee_image').toString();
        cEmployeePosition = prefs.getString('employee_position').toString();
        cRestapiUserName =
            prefs.getString('server_restapi').toString() + 'restapi_username/';
      },
    );
    var response = await http.post(
        Uri.parse(cRestapiUserName +
            'get_user_mainmenu' +
            '?db=' +
            cCompanyCode +
            '&username=' +
            cUserName),
        headers: {"Accept": "'application/json"});

    if (response.statusCode == 200) {
      setState(
        () {
          dataJSON = jsonDecode(response.body);
        },
      );
    }

    Map temp = new Map.from(dataJSON[0]);
    temp['mainmenu_code'] = 'FF1';
    temp['mainmenu_name'] = 'About';
    dataJSON.insert(dataJSON.length, temp);

    setState(() => isLoading = false);
  }

  void _logoutPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('strdate_login', 'aa');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: RexColors.AppBar,
                      size: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        text,
                        // Nunito Tinggal di rubah sesuai font yang diinginkan
                        style: GoogleFonts.nunito().copyWith(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
