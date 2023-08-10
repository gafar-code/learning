import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';

import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

class SalesKanvasCustomerUpdatePage extends StatefulWidget {
  final cDataID, cDataItems, cProject, cTrnDate;

  SalesKanvasCustomerUpdatePage(
      this.cDataID, this.cDataItems, this.cProject, this.cTrnDate);

  @override
  _SalesKanvasCustomerUpdatePageState createState() =>
      _SalesKanvasCustomerUpdatePageState();
}

class _SalesKanvasCustomerUpdatePageState
    extends State<SalesKanvasCustomerUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _entryCode = TextEditingController();
  TextEditingController _entryPrice = TextEditingController();
  TextEditingController _entryQty = TextEditingController();
  TextEditingController _entryAmount = TextEditingController();

  String cLanguage = '';
  String _equipmentName = "-";
  String cQty = '';
  String cAmount = '';

  List dataJSON = [];
  List dataProduct = [];

  bool isLoading = false;
  bool isClicked = false;

  _plus() {}

  _minus() {}

  @override
  void initState() {
    super.initState();
    _initCheck();

    if (widget.cDataID == '') {
      _entryPrice = TextEditingController(text: '0');
      _entryQty = TextEditingController(text: '0');
      _entryAmount = TextEditingController(text: '0');
    } else {
      _entryCode = widget.cDataItems['equipment_code'];
      _entryPrice = TextEditingController(text: widget.cDataItems['price']);
      _entryQty = TextEditingController(text: widget.cDataItems['qty']);
      _entryAmount = TextEditingController(text: widget.cDataItems['amount']);
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
        title: Text("Sales Update"),
        backgroundColor: rx_customs.RexColors.BarColor,
      ),
      backgroundColor: rx_customs.RexColors.BackGround,
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
//                    _widgetSearchEquipment(),
                    _widgetInventory(),
                    SizedBox(height: 10),
                    _widgetPrice(),
                    SizedBox(height: 10),
                    _widgetQty(),
                    SizedBox(height: 10),
                    _widgetAmount(),
                    SizedBox(height: 50),
                    _widgetButtonSave(),
                    SizedBox(height: 200),
                  ],
                ),
        ),
      ),
    );
  }

/*  Widget _widgetSearchEquipment() {
    return GestureDetector(
      onTap: () => _showEquipmentDialog(),
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
                _entryCode,
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
*/
  void _showEquipmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Product"),
          content: Container(
            height: 300,
            width: double.minPositive,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dataProduct.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _entryCode.text = dataProduct[i]['code'];
                      _entryPrice =
                          TextEditingController(text: dataProduct[i]['price']);
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text(
                      dataProduct[i]['code'],
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

  Widget _widgetInventory() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _entryCode,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(fontSize: 20),
        validator: (value) {
          isClicked = false;
          if (value == '') {
            return 'Invalid ' + rx_function.getText('Code') + '...';
          }
          return null;
        },
        onChanged: (val) {
          setState(() {
            _entryAmount.text =
                (int.parse(val) * int.parse(_entryPrice.text)).toString();
          });
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: rx_function.getText('Code') + '*',
          hintText: rx_function.getText('Code'),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: rx_customs.RexColors.EntryColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.greenAccent),
          ),
          suffixIcon: ElevatedButton(
            child: Icon(
              Icons.lock,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              _showEquipmentDialog();
            },
          ),
        ),
      ),
    );
  }

  Widget _widgetPrice() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _entryPrice,
        readOnly: true,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
            labelText: rx_function.getText('Price'),
            fillColor: rx_customs.RexColors.EntryColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(width: 3, color: rx_customs.RexColors.EntryBorder),
            ),
            filled: true),
      ),
    );
  }

  Widget _widgetQty() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _entryQty,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(fontSize: 20),
        validator: (value) {
          isClicked = false;
          if (value == '') {
            return 'Invalid ' + rx_function.getText('Qty') + '...';
          }
          return null;
        },
        onChanged: (val) {
          setState(() {
            _entryAmount.text =
                (int.parse(val) * int.parse(_entryPrice.text)).toString();
          });
        },
        decoration: InputDecoration(
          labelText: rx_function.getText('Qty'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: rx_customs.RexColors.EntryColor,
          filled: true,
          prefixIcon: ElevatedButton(
              child: Text("-1"),
              onPressed: () {
                setState(() {
                  cQty = (int.parse(_entryQty.text) - 1).toString();
                  cAmount = ((int.parse(_entryQty.text) - 1) *
                          int.parse(_entryPrice.text))
                      .toString();
                  _entryQty = TextEditingController(text: cQty);
                  _entryAmount = TextEditingController(text: cAmount);
                });
              }),
          suffixIcon: ElevatedButton(
            child: Text("+1"),
            onPressed: () {
              setState(() {
                cQty = (int.parse(_entryQty.text) + 1).toString();
                cAmount = ((int.parse(_entryQty.text) + 1) *
                        int.parse(_entryPrice.text))
                    .toString();
                _entryQty = TextEditingController(text: cQty);
                _entryAmount = TextEditingController(text: cAmount);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _widgetAmount() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _entryAmount,
        readOnly: true,
        style: TextStyle(fontSize: 20),
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: rx_function.getText('Amount'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            fillColor: rx_customs.RexColors.EntryColor,
            filled: true),
      ),
    );
  }

  Widget _widgetButtonSave() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: rx_customs.RexColors.ButtonCancel,
            ),
            child: Container(
              width: 110,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                rx_function.getText('Cancel'),
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
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
              backgroundColor: rx_customs.RexColors.ButtonSave,
            ),
            child: Container(
              width: 110,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                rx_function.getText('Save'),
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
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
    String cUserEntry = prefs.getString('userentry').toString();
    String cDeviceID = prefs.getString('device_id').toString();
    String cRestapiSalesKanvas =
        prefs.getString('server_restapi').toString() + 'restapi_sales_kanvas/';

    var response = await http.post(
        Uri.parse(cRestapiSalesKanvas +
            'save_kanvas_trnsales' +
            '?db=' +
            cCompanyCode +
            '&computer_id=' +
            cDeviceID +
            '&id=' +
            widget.cDataID +
            '&userentry=' +
            cUserEntry +
            '&code=' +
            _entryCode.text +
            '&qty=' +
            _entryQty.text +
            '&price=' +
            _entryPrice.text +
            '&amount=' +
            _entryAmount.text),
        headers: {"Accept": "'application/json"});

    Navigator.pop(context, true);
    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        style: AlertStyle(isCloseButton: false),
        title: rx_function.getText("DATA SAVED ..."),
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

  Future _initCheck() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cCompanyCode = prefs.getString('company_code').toString();
    String cRestapiSalesKanvas =
        prefs.getString('server_restapi').toString() + 'restapi_sales_kanvas/';

    var response = await http.get(
        Uri.parse(cRestapiSalesKanvas +
            'get_product_price' +
            '?db=' +
            cCompanyCode +
            '&groupprice_code=' +
            widget.cProject),
        headers: {"Accept": "'application/json"});

    dataProduct.clear();
    setState(() {
      if (response.statusCode == 200) {
        dataJSON = jsonDecode(response.body);
        dataProduct.addAll(dataJSON);
      }
      isLoading = false;
    });
  }
}
