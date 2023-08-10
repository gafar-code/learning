import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../10_home.dart';
import '../00_standard/12_language.dart';
import '../00_standard/12_function.dart' as rx_function;

class EntrySimpleUpdatePage extends StatefulWidget {
  final cDataID, cDataItems;
  EntrySimpleUpdatePage(this.cDataID, this.cDataItems);

  @override
  _EntrySimpleUpdatePageState createState() => _EntrySimpleUpdatePageState();
}

class _EntrySimpleUpdatePageState extends State<EntrySimpleUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  String cBuyDate = '';

  TextEditingController entryCode = TextEditingController();
  TextEditingController entryName = TextEditingController();

  String cLanguage = '';
  bool isLoading = false;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _initCheck();

    if (widget.cDataID == '') {
      entryCode = TextEditingController();
      entryName = TextEditingController();
    } else {
      entryCode = TextEditingController(text: widget.cDataItems['code']);
      entryName = TextEditingController(text: widget.cDataItems['name']);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry Simple Update"),
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
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    _entryCode(),
                    SizedBox(height: 10),
                    _entryName(),
                    _widgetBuyDate(),
                    SizedBox(height: 50),
                    _widgetButtonSaveDelete(),
                    SizedBox(height: 200),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _entryCode() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: entryCode,
        keyboardType: TextInputType.text,
        validator: (value) {
          isClicked = false;
          if (value == '') {
            return 'Invalid ' + setLanguage('Code', cLanguage) + '...';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: setLanguage('Code', cLanguage) + '*',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true),
      ),
    );
  }

  Widget _entryName() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: entryName,
        keyboardType: TextInputType.text,
        validator: (value) {
          isClicked = false;
          if (value == '') {
            return 'Invalid ' + setLanguage('Name', cLanguage) + '...';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: setLanguage('Name', cLanguage) + '*',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true),
      ),
    );
  }

  Widget _widgetBuyDate() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DateTimePicker(
        type: DateTimePickerType.date,
        dateMask: 'dd MMMM yyyy',
        initialValue: DateTime.now().toString(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        decoration: InputDecoration(
          labelText: "Buy Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
        onChanged: (val) {
          setState(() => cBuyDate = val);
        },
      ),
    );
  }

  Widget _widgetButtonSaveDelete() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.cDataID == ''
              ? ElevatedButton(
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
                      setLanguage('Cancel', cLanguage),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: isClicked
                      ? null
                      : () {
                          setState(() => isClicked = true);
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            style: AlertStyle(isCloseButton: false),
                            title: setLanguage("DELETE ???", cLanguage),
                            desc: "",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  setState(() => isClicked = false);
                                  Navigator.pop(context, true);
                                },
                              ),
                              DialogButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  _clickDelete();
                                },
                              )
                            ],
                          ).show();
                        },
                  style: ElevatedButton.styleFrom(
                    onPrimary: rx_function.RexColors.ButtonText,
                    primary: rx_function.RexColors.ButtonReject,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Text(
                      setLanguage('Delete', cLanguage),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
          ElevatedButton(
            onPressed: isClicked
                ? null
                : () {
                    setState(() => isClicked = true);
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
                setLanguage('Save', cLanguage),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clickDelete() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: CircularProgressIndicator(),
        ),
      ),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cUserName = prefs.getString('username').toString();
    String cRestapiUserName =
        prefs.getString('server_restapi').toString() + 'restapi_username/';

    var response = await http.delete(
        Uri.parse(cRestapiUserName +
            'delete_computer_access' +
            '?db=' +
            cCompanyCode +
            '&username=' +
            cUserName +
            '&id=' +
            widget.cDataID),
        headers: {"Accept": "'application/json"});

    Navigator.pop(context, true);

    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        style: AlertStyle(isCloseButton: false),
        title: setLanguage("DATA DELETED ...", cLanguage),
        desc: "",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        style: AlertStyle(isCloseButton: false),
        title: "NETWORK ERROR !!!",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() => isClicked = false);
              Navigator.pop(context, true);
            },
          )
        ],
      ).show();
    }
  }

  void _clickSave() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: CircularProgressIndicator(),
        ),
      ),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cUserName = prefs.getString('username').toString();
    String cRestapiUserName =
        prefs.getString('server_restapi').toString() + 'restapi_username/';

    var response;
    if (widget.cDataID == '') {
      response = await http.post(
          Uri.parse(cRestapiUserName +
              'save_computer_access' +
              '?db=' +
              cCompanyCode +
              '&username=' +
              cUserName +
              '&code=' +
              entryCode.text.toUpperCase() +
              '&name=' +
              entryName.text),
          headers: {"Accept": "'application/json"});
    } else {
      response = await http.put(
          Uri.parse(cRestapiUserName +
              'update_computer_access' +
              '?db=' +
              cCompanyCode +
              '&username=' +
              cUserName +
              '&code=' +
              entryCode.text.toUpperCase() +
              '&name=' +
              entryName.text +
              '&id=' +
              widget.cDataID),
          headers: {"Accept": "'application/json"});
    }

    Navigator.pop(context, true);
    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        style: AlertStyle(isCloseButton: false),
        title: setLanguage("DATA SAVED ...", cLanguage),
        desc: "",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        style: AlertStyle(isCloseButton: false),
        title: "NETWORK ERROR !!!",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() => isClicked = false);
              Navigator.pop(context, true);
            },
          )
        ],
      ).show();
    }
  }

  void _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    cLanguage = prefs.getString('userlanguage').toString();

    setState(() => isLoading = false);
  }
}
