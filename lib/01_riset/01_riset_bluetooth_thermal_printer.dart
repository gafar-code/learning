import 'dart:developer';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:learning/models/data_termal_model.dart';
import 'package:learning/utils/helpers.dart';

import '../00_customs/10_customs.dart' as rx_customs;
import '../00_standard/12_function.dart' as rx_function;

class RisetBluettothThermalPrinterPage extends StatefulWidget {
  const RisetBluettothThermalPrinterPage({super.key, required this.data});

  final DataThermalModel data;

  @override
  State<RisetBluettothThermalPrinterPage> createState() => _RisetBluettothThermalPrinterState();
}

class _RisetBluettothThermalPrinterState extends State<RisetBluettothThermalPrinterPage> {
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
        title: const Text("Canvas Print"),
        backgroundColor: rx_customs.RexColors.BarColor,
      ),
      backgroundColor: rx_customs.RexColors.BackGround,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardGroup(context),
                _cardBlank(context),
              ],
            ),
            const SizedBox(height: 50),
            _connected
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Connected : $_entryName",
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: !_connected ? null : _print,
                child: const Text('PRINT', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
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
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: rx_customs.RexColors.CardHeader,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Printer",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    _entryName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: rx_function.RexColors.AppBar),
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
          content: SizedBox(
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
            margin: const EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _connected ? Colors.red : Colors.green),
              onPressed: _entryName == 'NONE'
                  ? null
                  : _connected
                      ? _disconnect
                      : _connect,
              child: Text(
                _connected ? 'Disconnect' : 'Connect',
                style: const TextStyle(color: Colors.white),
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
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude.toString();
      long = position.longitude.toString();
      cLocation = '$lat,$long';

      try {
        List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);
        Placemark placeMark = newPlace[0];
        String cSubLocality = placeMark.subLocality.toString();
        String cLocality = placeMark.locality.toString();
        String cSubAdministrativeArea = placeMark.subAdministrativeArea.toString();
        String cPostalCode = placeMark.postalCode.toString();

        cAddress1 = '$cSubLocality, $cLocality';
        cAddress2 = '$cSubAdministrativeArea, $cPostalCode';
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
    if (_entryMac == 'NONE') {
      log("Cannot Connect");
      _showErrorDialog(context, "Choose Printer First");
    } else {
      try {
        await BluetoothThermalPrinter.connect(_entryMac);
      } on PlatformException catch (e) {
        log(e.toString());
        setState(() => _connected = false);
      }
      setState(() => _connected = true);
    }
  }

  void _disconnect() async {
    try {
      await BluetoothThermalPrinter.connect(_entryMac);
    } on PlatformException catch (e) {
      log(e.toString());
      setState(() => _connected = false);
    }
    setState(() => _connected = true);
  }

  void _print() async {
    int total = 0;

    if (_entryMac == 'NONE') {
      _showErrorDialog(context, "Choose Printer First");
      return;
    }

    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text("", styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

// HEADER
    bytes += generator.text(
      widget.data.name,
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
    );

    bytes += generator.text(
      widget.data.province,
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
    );
    bytes += generator.hr();

// SUBHEADER-1 [LEFT-RIGHT]
    bytes += generator.row([
      PosColumn(
        text: 'Sales: ${widget.data.sales}',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: widget.data.date,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: widget.data.codeSales,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
          text: widget.data.time,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.text('', styles: const PosStyles(align: PosAlign.left));

// SUBHEADER-2
    bytes += generator.row([
      PosColumn(text: 'Keterangan', width: 8, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Jumlah', width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr();

// DETAIL
    for (int i = 0; i < widget.data.items.length; i++) {
      Item item = widget.data.items[i];

      total += (item.quantity * item.price);

      bytes += generator.row([
        PosColumn(text: "${i + 1}", width: 1),
        PosColumn(
            text: item.name,
            width: 7,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(text: "", width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes += generator.row([
        PosColumn(text: "", width: 1),
        PosColumn(
            text: "${item.quantity} Pcs  x ${formatCurrency(item.price)}",
            width: 7,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(text: "${item.quantity * item.price}", width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);

      if (i == widget.data.items.length) {
        bytes += generator.hr();
      } else {
        bytes += generator.text('', styles: const PosStyles(align: PosAlign.left));
      }
    }

// FOOTER
    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 3,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: formatCurrency(total),
          width: 9,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.text('Terima Kasih', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('');

    bytes += generator.qrcode(widget.data.qrcode);
    bytes += generator.hr();
    bytes += generator.text(cAddress1, styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text(cAddress2, styles: const PosStyles(align: PosAlign.left));

    bytes += generator.text('');
    bytes += generator.text('');

    await BluetoothThermalPrinter.writeBytes(bytes);
  }

  Future _showErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(_message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
