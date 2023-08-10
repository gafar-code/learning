import 'package:flutter/material.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

class RisetBluettothThermalPrinterPage extends StatefulWidget {
  @override
  State<RisetBluettothThermalPrinterPage> createState() =>
      _RisetBluettothThermalPrinterState();
}

class _RisetBluettothThermalPrinterState
    extends State<RisetBluettothThermalPrinterPage> {
  String _entryName = 'NONE';
  String _entryMac = 'NONE';
  String lat = '';
  String long = '';
  String cLocation = '';
  String cAddress1 = '';
  String cAddress2 = '';
  String cPostalCode = '';

  bool _connected = false;
  bool isLoading = false;

  String pathImage = '';
  List availableBluetoothDevices = [];
  List dataDevice = [];

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canvas Print"),
        backgroundColor: rx_customs.RexColors.BarColor,
      ),
      backgroundColor: rx_customs.RexColors.BackGround,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardGroup(context),
                  _cardBlank(context),
                ],
              ),
              SizedBox(height: 50),
              _connected
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Connected : " + _entryName,
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: !_connected ? null : _print,
                  child: Text('PRINT', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardGroup(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 70,
        child: GestureDetector(
          onTap: () => _showGroupDialog(),
          child: Card(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: rx_customs.RexColors.CardHeader,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Printer",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    _entryName,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: rx_function.RexColors.AppBar),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 300,
            width: double.minPositive,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: availableBluetoothDevices.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      String select = availableBluetoothDevices[index];
                      List list = select.split("#");
                      _entryName = list[0];
                      _entryMac = list[1];
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text('${availableBluetoothDevices[index]}'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _cardBlank(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 70,
        child: GestureDetector(
          onTap: () => _showGroupDialog(),
          child: Card(
            margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _connected ? Colors.red : Colors.green),
              onPressed: _entryName == 'NONE'
                  ? null
                  : _connected
                      ? _disconnect
                      : _connect,
              child: Text(
                _connected ? 'Disconnect' : 'Connect',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _initCheck() async {
    setState(() => isLoading = true);

    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    setState(() {
      availableBluetoothDevices = bluetooths!;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude.toString();
      long = position.longitude.toString();
      cLocation = lat + ',' + long;

      try {
        List<Placemark> newPlace = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark placeMark = newPlace[0];
        String cSubLocality = placeMark.subLocality.toString();
        String cLocality = placeMark.locality.toString();
        String cSubAdministrativeArea =
            placeMark.subAdministrativeArea.toString();
        String cPostalCode = placeMark.postalCode.toString();

        cAddress1 = cSubLocality + ', ' + cLocality;
        cAddress2 = cSubAdministrativeArea + ', ' + cPostalCode;
      } catch (e) {
        cAddress1 = '.';
        cAddress2 = '.';
      }
    } catch (e) {
      lat = '.';
      long = '.';
    }
  }

  void _connect() async {
    print('string ' + _entryMac);
    if (_entryMac == 'NONE') {
      print("Cannot Connect");
      _showErrorDialog(context, "Choose Printer First");
    } else {
      try {
        await BluetoothThermalPrinter.connect(_entryMac);
      } on PlatformException catch (e) {
        print(e.toString());
        setState(() => _connected = false);
      }
      setState(() => _connected = true);
    }
  }

  void _disconnect() async {
    try {
      await BluetoothThermalPrinter.connect(_entryMac);
    } on PlatformException catch (e) {
      print(e.toString());
      setState(() => _connected = false);
    }
    setState(() => _connected = true);
  }

  void _print() async {
    if (_entryMac == 'NONE') {
      _showErrorDialog(context, "Choose Printer First");
      return;
    }
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    print("hello " + isConnected.toString());

    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text("",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

// HEADER
    bytes += generator.text(
      "PT. MERAPI MAJU MAKMUR",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );

    bytes += generator.text(
      "JAKARTA",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true),
    );
    bytes += generator.hr();

// SUBHEADER-1 [LEFT-RIGHT]
    bytes += generator.row([
      PosColumn(
        text: 'Sales: Agus',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "08/Agt/2023",
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'AGS-00012/230808',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
          text: "10:23",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.text('', styles: PosStyles(align: PosAlign.left));

// SUBHEADER-2
    bytes += generator.row([
      PosColumn(
          text: 'Keterangan',
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Jumlah',
          width: 4,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr();

// DETAIL
    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Lemari 2 Pintu",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(text: "", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "", width: 1),
      PosColumn(
          text: "10 Pcs  x 15.000",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "150.000", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.text('');

    bytes += generator.row([
      PosColumn(text: "2", width: 1),
      PosColumn(
          text: "Kursi Lebar",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(text: "", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "", width: 1),
      PosColumn(
          text: "5 Pcs  x 7.000",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "35.000", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.text('', styles: PosStyles(align: PosAlign.left));

    bytes += generator.row([
      PosColumn(text: "3", width: 1),
      PosColumn(
          text: "Kunci",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(text: "", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "", width: 1),
      PosColumn(
          text: "1 Pcs  x 5.000",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "5.000", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.text('', styles: PosStyles(align: PosAlign.left));

    bytes += generator.row([
      PosColumn(text: "4", width: 1),
      PosColumn(
          text: "Tambahan",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(text: "", width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "", width: 1),
      PosColumn(
          text: "1 Pcs  x 1.200.000",
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "1.200.000",
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();

// FOOTER
    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 3,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: "1.390.000",
          width: 9,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.text('Terima Kasih',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('');

    bytes += generator.qrcode('NomoruntukQRISDinamic');
    bytes += generator.hr();
    bytes += generator.text(cAddress1, styles: PosStyles(align: PosAlign.left));
    bytes += generator.text(cAddress2, styles: PosStyles(align: PosAlign.left));

    bytes += generator.text('');
    bytes += generator.text('');
    var result = await BluetoothThermalPrinter.writeBytes(bytes);
  }

  void _print2() async {
    if (_entryMac == 'NONE') {
      _showErrorDialog(context, "Choose Printer First");
      return;
    }
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    print("hello " + isConnected.toString());

    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
// Print QR Code using native function
    bytes += generator.qrcode('example.com');
    bytes += generator.hr();
// Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.cut();
    var result = await BluetoothThermalPrinter.writeBytes(bytes);
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
