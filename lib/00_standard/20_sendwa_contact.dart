import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;

class SendWAContactPage extends StatefulWidget {
  final cDescr;
  SendWAContactPage({this.cDescr});

  @override
  _SendWAContactPageState createState() => _SendWAContactPageState();
}

class _SendWAContactPageState extends State<SendWAContactPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _entryDescr = TextEditingController();

  String _entryType = '';
  // ignore: unused_field
  String _entryNo = '';

  bool isLoading = false;
  List dataJSON = [];
  List dataContact = [];

  @override
  void initState() {
    super.initState();
    _initCheck();
    _entryDescr.text = widget.cDescr;
  }

  @override
  Widget build(BuildContext context) {
// 3.10. AppBar & ActionButton

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Send WA",
        ),
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

// 3.20. Body (Entry)
      body: Container(
        margin: EdgeInsets.all(10.0),
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
                      SizedBox(height: 20),
                      _widgetType(),
                      SizedBox(height: 10),
                      _widgetDescr(),
                      SizedBox(height: 20),
                      _widgetButtonSave(),
                      SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetType() {
    return GestureDetector(
      onTap: () => _showTypeDialog(),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _entryType,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black54),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: rx_function.RexColors.AppBar,
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(5))),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Type"),
          content: Container(
            height: 300,
            width: double.minPositive,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dataContact.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _entryType = dataContact[i]['name'];
                      _entryNo = dataContact[i]['phone'];
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text(
                      dataContact[i]['name'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _widgetDescr() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 25, 10),
      child: TextFormField(
        controller: _entryDescr,
        keyboardType: TextInputType.multiline,
        minLines: 10,
        maxLines: 20,
        validator: (value) {
          if (value == '') {
            return 'Invalid Descr...';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Descr*',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );
  }

  Widget _widgetButtonSave() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              onPrimary: rx_function.RexColors.ButtonText,
              primary: rx_function.RexColors.ButtonTo,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _clickSave();
              }
            },
            style: ElevatedButton.styleFrom(
              onPrimary: rx_function.RexColors.ButtonText,
              primary: rx_function.RexColors.ButtonTo,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                '  Send  ',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cEmployeeCode = prefs.getString('employee_code').toString();
    String cRestapiCompany =
        prefs.getString('server_restapi').toString() + 'restapi_company/';

    var response = await http.post(
        Uri.parse(cRestapiCompany +
            'get_personalcontact' +
            '?db=' +
            cCompanyCode +
            '&employee_code=' +
            cEmployeeCode),
        headers: {"Accept": "'application/json"});

    dataContact.clear();
    setState(
      () {
        if (response.statusCode == 200) {
          dataJSON = jsonDecode(response.body);
          dataContact.addAll(dataJSON);
        }
        isLoading = false;
      },
    );
  }

  void _clickSave() async {
//    FlutterOpenWhatsapp.sendSingleMessage("+62" + _entryNo, _entryDescr.text);
    Navigator.pop(context);
  }
}
