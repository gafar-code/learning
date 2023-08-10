import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import '10_home.dart';
import '00_standard/12_language.dart';
import '00_standard/12_function.dart' as rx_function;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String cHeaderName = 'Rexion';
  String cHeaderLogo = '';
  Color cColorFrom = Color(0xFF29B6F6); //lightBlue[400];
  Color cColorTo = Color(0xFF0288D1); //lightBlue[700];

  String cDeviceID = '';
  String cServer = '';
  String cCompany = '';
  String cCurrentVersion = '';
  String cAppName = '';
  String cVersion = '';
  String cPackageName = '';
  String cBuildNumber = '';
  String cSupervisor = '';
  String cLanguage = 'id';

  List listCompanyCode = [];

  bool isLoading = true;

  TextEditingController entryCompanyCode = TextEditingController();
  TextEditingController entryUserName = TextEditingController();
  TextEditingController entryPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var response;
  var isEntry = false;

  @override
  void initState() {
    super.initState();
    _initCheck();
    entryCompanyCode.text = '101-testing';
    entryUserName.text = 'HR-0001';
    entryPassword.text = '123';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              isEntry ? _headerName() : _headerMenu(),
                              SizedBox(height: 20),
                              _entryCompanyCode(),
                              _entryUserName(),
                              _entryPassword(),
                              SizedBox(height: 30),
                              _buttonLogin(),
                              SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _headerName() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cColorFrom, cColorTo],
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                  text: cHeaderName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _headerMenu() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cColorFrom, cColorTo],
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: cHeaderLogo != ''
                ? Image.network(
                    cHeaderLogo,
                    width: 80,
                    height: 80,
                  )
                : Image.asset(
                    'assets/logo.png',
                    width: 80,
                    height: 80,
                  ),
          ),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                  text: cHeaderName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _entryCompanyCode() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          TextFormField(
            onTap: () {
              isEntry = true;
            },
            controller: entryCompanyCode,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == '') {
                return 'Invalid ' +
                    setLanguage("Company Code", cLanguage) +
                    '...';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: setLanguage("Company Code", cLanguage),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: Icon(
                  Icons.business,
                  color: rx_function.RexColors.Icon,
                  size: 25,
                ),
                suffixIcon: PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    entryCompanyCode.text = value.toString();
                  },
                  itemBuilder: (BuildContext context) {
                    return listCompanyCode.map<PopupMenuItem>((value) {
                      return new PopupMenuItem(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: new Text(value),
                        ),
                        value: value,
                      );
                    }).toList();
                  },
                ),
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _entryUserName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            onTap: () {
              isEntry = true;
            },
            controller: entryUserName,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == '') {
                return 'Invalid ' +
                    setLanguage("Employee ID", cLanguage) +
                    '...';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: setLanguage("Employee ID", cLanguage),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: rx_function.RexColors.Icon,
                  size: 25,
                ),
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _entryPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          TextFormField(
            onTap: () {
              isEntry = true;
            },
            obscureText: true,
            controller: entryPassword,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == '') {
                return 'Invalid Password...';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: rx_function.RexColors.Icon,
                  size: 25,
                ),
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _buttonLogin() {
    return InkWell(
      onTap: () {
        _clickLogin();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                rx_function.RexColors.ButtonFrom,
                rx_function.RexColors.ButtonTo
              ],
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 20, color: rx_function.RexColors.ButtonText),
          ),
        ),
      ),
    );
  }

  void _clickLogin() async {
    List dataJSON = [];
    List dataTemp = [];
    String cEmployeeName;
    String cUserEntry;

    String cTrnDate = DateFormat('yyyy-MM-dd').format(
      DateTime.now(),
    );
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: CircularProgressIndicator(),
        ),
      ),
    );

    entryCompanyCode.text = entryCompanyCode.text.trim();
    entryUserName.text = entryUserName.text.trim();
    entryPassword.text = entryPassword.text.trim();
    cCompany = entryCompanyCode.text.trim();

    cServer = 'http://117.53.44.150/';
    var response2 = await http.post(
        Uri.parse(cServer +
            'apps/index.php/restapi_username/get_view_user' +
            '?db=' +
            cCompany +
            '&username=' +
            entryUserName.text.trim()),
        headers: {"Accept": "'application/json"});

//333333
    if (response2.statusCode != 200) {
      Navigator.pop(context, true);

      return _showErrorDialog(context, 'Invalid Username !!!');
    } else {
      dataJSON = jsonDecode(response2.body);
      var cResult1 = dataJSON[0]['access'];
      var cResult2 = dataJSON[0]['userpassword'];
      var cResult3 = md5.convert(utf8.encode(entryPassword.text)).toString();

//555555
      if (cResult2 != cResult3) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('company_code', cCompany);
        prefs.setString('username', entryUserName.text.trim());

        Navigator.pop(context, true);

        return _showErrorDialog(context, 'Invalid Password !!!');
      } else {
//666666
        if (dataJSON[0]['employee_code'] == null) {
          Navigator.pop(context, true);

          return _showErrorDialog(context, 'Invalid Employee Code !!!');
        } else {
//IN
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (!listCompanyCode.contains(entryCompanyCode.text)) {
            listCompanyCode.add(entryCompanyCode.text);
          }

          String listCompany = jsonEncode(listCompanyCode);

          prefs.setString('list_company_code', listCompany);

          prefs.setString('company_code', cCompany);
          prefs.setString('username', entryUserName.text.trim());

          prefs.setString('strdate_login', cTrnDate);
          prefs.setString('employee_id', dataJSON[0]['employee_id']);
          prefs.setString('employee_code', dataJSON[0]['employee_code']);
          prefs.setString('employee_name', dataJSON[0]['employee_name']);
          prefs.setString('company_name', dataJSON[0]['company_name']);
          prefs.setString('company_city', dataJSON[0]['company_city']);

          prefs.setString('userattendance', dataJSON[0]['imei']);
          prefs.setString(
              'employee_position',
              dataJSON[0]['position_code'] != null
                  ? dataJSON[0]['position_code']
                  : '...');
          prefs.setString(
              'employee_image',
              dataJSON[0]['employee_image'] != null
                  ? dataJSON[0]['employee_image']
                  : '001.jpg');
          prefs.setString('userlanguage',
              dataJSON[0]['dashboard'] != '' ? dataJSON[0]['dashboard'] : 'id');
          prefs.setString('useradmin', dataJSON[0]['mobapp']);
          prefs.setString('usermenu', dataJSON[0]['mobapp']);

          cEmployeeName = dataJSON[0]['employee_name'] + ' ';

          if (cEmployeeName.length > 15) {
            cEmployeeName = cEmployeeName.substring(0, 15) + ' ';
          }
          cUserEntry = cEmployeeName.substring(0, cEmployeeName.indexOf(' '));
          cUserEntry = cUserEntry.toLowerCase() +
              ' [' +
              dataJSON[0]['employee_code'] +
              ']';
          prefs.setString('userentry', cUserEntry);

          var cImage = dataJSON[0]['employee_image'] != null
              ? dataJSON[0]['employee_image']
              : '';
          if (cImage == '') {
            cImage = '010.jpg';
          }

          var cDirEmployee = cServer +
              'company/' +
              cCompany.substring(0, 3) +
              '_' +
              cCompany.substring(4).trim() +
              '/employee/' +
              cImage;
          prefs.setString('employee_image', cDirEmployee);

          var cDirCompany = cServer +
              'apps/rexion_logo/logo_' +
              cCompany.substring(0, 3) +
              '_' +
              cCompany.substring(4).trim() +
              '.png';
          prefs.setString('company_logo', cDirCompany);

          prefs.setString('server_restapi', cServer + 'apps/index.php/');
          prefs.setString(
              'server_file',
              cServer +
                  'company/' +
                  cCompany.substring(0, 3) +
                  '_' +
                  cCompany.substring(4).trim() +
                  '/');

          var cCompanyAttendance = '';
          var response3 = await http.post(
              Uri.parse(cServer +
                  'apps/index.php/restapi_simple/get_general_setup' +
                  '?db=' +
                  cCompany.trim() +
                  '&code=' +
                  'SYSTEM_PAYROLL_ATTENDANCE'),
              headers: {"Accept": "'application/json"});
          if (response3.statusCode == 200) {
            dataTemp = jsonDecode(response3.body);
            if (dataTemp[0]['name01'] != null) {
              cCompanyAttendance = dataTemp[0]['name01'];
            }
          }
          prefs.setString('company_attendance', cCompanyAttendance);

          var response4 = await http.post(
              Uri.parse(cServer +
                  'apps/index.php/restapi_username/save_loginlog' +
                  '?db=' +
                  cCompany.trim() +
                  '&username=' +
                  entryUserName.text.trim() +
                  '&version=' +
                  cVersion +
                  '.' +
                  cBuildNumber +
                  '&application=' +
                  cPackageName +
                  '&mobile_id=' +
                  cDeviceID +
                  '&descr=' +
                  cDeviceID +
                  ', ' +
                  cUserEntry),
              headers: {"Accept": "'application/json"});
          if (response4.statusCode == 200) {}

          var response5 = await http.post(
              Uri.parse('http://117.53.44.150/' +
                  'apps/index.php/restapi_server/save_mobapp_loginlog' +
                  '?db=' +
                  '200-rexion' +
                  '&username=' +
                  entryUserName.text.trim() +
                  '&computer_id=' +
                  cDeviceID +
                  '&application=' +
                  cPackageName +
                  '&version=' +
                  cVersion +
                  '.' +
                  cBuildNumber +
                  '&servername=' +
                  cCompany.trim() +
                  '&company=' +
                  cCompany.substring(4).trim() +
                  '&create_by=' +
                  entryUserName.text.trim() +
                  '&descr=' +
                  cEmployeeName),
              headers: {"Accept": "'application/json"});
          if (response5.statusCode == 200) {}
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  void _initCheck() async {
    setState(() => isLoading = true);

    String cCompanyCode = '';
    String cUserName = '';
    String cGetHeader = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        cDeviceID = prefs.getString('device_id').toString();
        cSupervisor = prefs.getString('supervisor_login') != null
            ? prefs.getString('supervisor_login').toString()
            : "";
        cLanguage = prefs.getString('userlanguage').toString();

        var prefListCompany = prefs.getString('list_company_code') ?? null;

        if (prefListCompany != null) {
          List listCompany = jsonDecode(prefListCompany);
          listCompanyCode.addAll(listCompany);
          entryCompanyCode.text = listCompanyCode[0].toString();
        }
      },
    );
    cLanguage = 'id';

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

  Future _showErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(_message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
      context: context,
    );
  }
}
