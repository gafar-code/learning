import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
import '00_standard/12_language.dart';
import '00_standard/12_function.dart' as rx_function;
import '17_login.dart';
import '00_standard/11_home_drawer.dart';

import '../25_saleskanvas/25_saleskanvas.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String cEmployeeCode = '';
  String cEmployeeName = '';
  String cEmployeeImage = '';
  String cEmployeePosition = '';
  String cServerFile = '';
  String cCompanyAttendance = '';
  String cUserAttendance = '';
  String cUserMenu = '';
  String cLanguage = '';

  int nMax = 0;
  int nQtyApproval = 0;
  int nQtyToDo = 0;
  int nQtyReimbursement = 0;

  List dataJSON = [];
  List dataItems = [];
  bool isLoading = false;

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
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
          new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logoutPage,
          )
        ],
      ),
      drawer: HomeDrawer(),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * 25 / 100,
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: rx_function.RexColors.Header,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(7),
              ),
            ),
          ),
          ListView(
            children: [
              isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          _welcomeUser(),
                          SizedBox(height: 20),
                          _cardMenu(),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _cardToday(size),
                              _cardCheck(size),
                            ],
                          ),
                          SizedBox(height: 20),
                          _cardCompanyMessage(),
                          SizedBox(height: 200),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _welcomeUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              cEmployeeImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                setLanguage("Welcome,", cLanguage),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                cEmployeeName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                cEmployeePosition,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Inisialisasi Card Menu
  Widget _cardMenu() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          children: [
            _gridItems(
              "home_todo.png",
              "To Do",
              nQtyToDo.toString(),
              () {},
            ),
            _gridItems(
              "home_approval.png",
              "Sales Kanvas",
              nQtyApproval.toString(),
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesKanvasPage(),
                  ),
                )
              },
            ),
            _gridItems(
              "home_meeting.png",
              "Project",
              "0",
              () {},
            ),
            _gridItems(
              "home_note.png",
              "Notes",
              "0",
              () => {},
            ),
            _gridItems(
              "home_attendance.png",
              setLanguage("Attendance", cLanguage),
              "0",
              () => {},
            ),
            _gridItems(
              "home_notification.png",
              "Scan QR",
              "0",
              () {},
            ),
            _gridItems(
              "home_discussion.png",
              "Koperasi",
              "0",
              () => {},
            ),
            cUserAttendance == 'QRCODE'
                ? _gridItems(
                    "home_contact.png",
                    "QR Code",
                    "0",
                    () => {},
                  )
                : _gridItems(
                    "home_contact.png",
                    "Friend",
                    "0",
                    () => {},
                  ),
          ],
        ),
      ),
    );
  }

  Widget _gridItems(
      String img, String text, String nCount, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: GridTile(
          child: Container(
            padding: EdgeInsets.only(bottom: 20, top: 5),
            child: Image.asset(
              "assets/$img",
            ),
          ),
          header: nCount != "0"
              ? badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 5),
                  badgeContent: Text(
                    nCount,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  child: Text(''),
                )
              : Text(''),
          footer: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Card Today
  Widget _cardToday(Size size) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: size.height * 20 / 100,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: size.width * 60 / 100,
                height: size.height * 5 / 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                ),
                child: Text(
                  cUserMenu,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Card Check
  Widget _cardCheck(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.green,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10),
              width: size.width * 40 / 100,
              height: size.height * 9 / 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 25,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Check In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.purple,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10),
              width: size.width * 40 / 100,
              height: size.height * 9 / 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 25,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Check Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardCompanyMessage() {
    Size size = MediaQuery.of(context).size;
    bool isTablet;
    if (size.width > 600) {
      isTablet = true;
    } else {
      isTablet = false;
    }

    return Container(
      color: rx_function.RexColors.BackGround,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Company News",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "See More",
                    style: TextStyle(
                      fontSize: 16,
                      color: rx_function.RexColors.AppBar,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: isTablet
                        ? (size.height / 8) * 3.5
                        : (size.height / 8) * 2.5,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: nMax,
                        itemBuilder: (BuildContext context, int index) =>
                            buildListView(context, index)),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildListView(BuildContext context, int index) {
    return GestureDetector(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.7,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  cServerFile + dataItems[index]['image_name'],
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height / 8) * 1.6,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  dataItems[index]['header'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  dataItems[index]['descr'],
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              )
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
    String cUserName = prefs.getString('username').toString();
    String cRestapiCompany =
        prefs.getString('server_restapi').toString() + 'restapi_company/';
    String cRestapiApproval =
        prefs.getString('server_restapi').toString() + 'restapi_approval/';
    String cRestapiEmployee =
        prefs.getString('server_restapi').toString() + 'restapi_employee/';

    cEmployeeCode = prefs.getString('employee_code').toString();
    cEmployeeName = prefs.getString('employee_name').toString();
    cEmployeePosition = prefs.getString('employee_position').toString();
    cEmployeeImage = prefs.getString('employee_image').toString();
    cServerFile = prefs.getString('server_file').toString() + 'company/';
    cCompanyAttendance = prefs.getString('company_attendance').toString();
    cUserAttendance = prefs.getString('userattendance').toString();
    cUserMenu = prefs.getString('usermenu').toString();
    cLanguage = prefs.getString('userlanguage').toString();

    var response = await http.get(
        Uri.parse(cRestapiCompany +
            'get_companynews' +
            '?db=' +
            cCompanyCode +
            '&username=' +
            cUserName),
        headers: {"Accept": "'application/json"});

    var response1 = await http.post(
        Uri.parse(cRestapiApproval +
            'get_approval_openqty' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    var response2 = await http.post(
        Uri.parse(cRestapiEmployee +
            'get_todo_openqty' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    var response3 = await http.post(
        Uri.parse(cRestapiCompany +
            'get_reimbursement_openqty' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    nQtyApproval = 0;
    nQtyToDo = 0;
    nQtyReimbursement = 0;

    setState(() {
      if (response.statusCode == 200) {
        dataJSON = jsonDecode(response.body);
        dataItems.addAll(dataJSON);
      }
      dataJSON.length > 5 ? nMax = 5 : nMax = dataJSON.length;

      if (response1.statusCode == 200) {
        dataJSON = jsonDecode(response1.body);
        if (dataJSON[0]['qty'] != null) {
          nQtyApproval = int.parse(dataJSON[0]['qty']);
        }
      }

      if (response2.statusCode == 200) {
        dataJSON = jsonDecode(response2.body);
        if (dataJSON[0]['qty'] != null) {
          nQtyToDo = int.parse(dataJSON[0]['qty']);
        }
      }

      if (response3.statusCode == 200) {
        dataJSON = jsonDecode(response3.body);
        if (dataJSON[0]['qty'] != null) {
          nQtyReimbursement = int.parse(dataJSON[0]['qty']);
        }
      }

      isLoading = false;
    });
  }

  void _logoutPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('strdate_login', 'aa');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
