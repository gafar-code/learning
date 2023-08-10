import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:async';
import 'dart:io';
import '10_home.dart';
import '17_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Learning', home: Splash(), debugShowCheckedModeBanner: false);
  }
}

class Splash extends StatefulWidget {
  Splash();

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String cLoginDate = '';
  String cTrnDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _initCheck();
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (c) => isLogin ? HomePage() : LoginPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Image.asset(
          "assets/rexionone.png",
          width: 150.0,
          height: 200.0,
        ),
      ),
    );
  }

  void _initCheck() async {
    String cDeviceID = '';
    String cBuildNumber = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('device_id', cDeviceID);
    prefs.setString('build_number', cBuildNumber);
    prefs.setString('userlanguage', 'id');

    isLogin = false;
    if (prefs.getString('strdate_login') != null) {
      setState(
        () {
          cLoginDate = prefs.getString('strdate_login').toString();
          if (cLoginDate == cTrnDate) {
            isLogin = true;
          }
        },
      );
    }
  }
}
