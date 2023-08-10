import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
import '11_home_drawer.dart';
import '12_language.dart';
import '../01_riset/01_riset_location.dart';
import '../01_riset/01_riset_deviceinfo.dart';
import '../01_riset/01_riset_qrscanner.dart';

class HomeAboutPage extends StatefulWidget {
  @override
  _HomeAboutPageState createState() => _HomeAboutPageState();
}

class _HomeAboutPageState extends State<HomeAboutPage> {
  String cLanguage = '';

  String cAppName = '';
  String cVersion = '';
  String cPackageName = '';
  String cBuildNumber = '';

  List dataJSON = [];
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
        title: Text("About"),
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
      drawer: HomeDrawer(),
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
                  SizedBox(height: 10),
                  _listProfile1(),
                  SizedBox(height: 10),
                  _listProfile2(),
                  SizedBox(height: 10),
                  _listProfile3(),
                  SizedBox(height: 10),
                  _listProfile4(),
                  SizedBox(height: 10),
                  _widgetButtonGeoLocation(),
                  SizedBox(height: 10),
                  _widgetButtonDeviceInfo(),
                  SizedBox(height: 10),
                  _widgetButtonQRScanner(),
                  SizedBox(height: 200),
                ],
              ),
      ),
    );
  }

  Widget _listProfile1() {
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/logo.png'),
          ),
        ],
      ),
    );
  }

  Widget _listProfile2() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          _buildHeader(setLanguage('Company', cLanguage)),
          _buildDivider(),
          _buildDescrOnly('PT. Rexion Teknologi Indonesia'),
          _buildDescrOnly('Jakarta'),
          _buildDescrOnly('Version : ' + cVersion),
          _buildDescrOnly('Build Number : ' + cBuildNumber),
        ],
      ),
    );
  }

  Widget _listProfile3() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          _buildHeader(setLanguage('Contact', cLanguage)),
          _buildDivider(),
          _buildDescrOnly('0881 080 333 777  (WA Only)'),
          _buildDescrOnly('rexionteknologi@gmail.com'),
        ],
      ),
    );
  }

  Widget _listProfile4() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          _buildHeader(setLanguage('Device', cLanguage)),
          _buildDivider(),
          _buildDescrOnly(
              'width : ' + MediaQuery.of(context).size.width.toString()),
          _buildDescrOnly(
              'height : ' + MediaQuery.of(context).size.height.toString()),
          _buildDescrOnly('pixel ratio : ' +
              MediaQuery.of(context).devicePixelRatio.toString()),
        ],
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    cLanguage = prefs.getString('userlanguage').toString();

    PackageInfo.fromPlatform().then(
      (PackageInfo packageInfo) {
        setState(
          () {
            cAppName = packageInfo.appName;
            cPackageName = packageInfo.packageName;
            cVersion = packageInfo.version;
            cBuildNumber = packageInfo.buildNumber;
          },
        );
      },
    );

    setState(() => isLoading = false);
  }

  Widget _widgetButtonGeoLocation() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeAboutLocationPage()));
            },
            style: ElevatedButton.styleFrom(
              onPrimary: rx_function.RexColors.ButtonText,
              primary: rx_function.RexColors.ButtonTo,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'GeoLocation',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetButtonDeviceInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeAboutDeviceInfoPage()));
            },
            style: ElevatedButton.styleFrom(
              onPrimary: rx_function.RexColors.ButtonText,
              primary: rx_function.RexColors.ButtonTo,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Device Info',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetButtonQRScanner() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeAboutQRScannerPage()));
            },
            style: ElevatedButton.styleFrom(
              onPrimary: rx_function.RexColors.ButtonText,
              primary: rx_function.RexColors.ButtonTo,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'QR Scanner',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildDescrOnly(cHeader) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  cHeader,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
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
