import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../10_home.dart';

class HomeAboutBluetoothPage extends StatefulWidget {
  const HomeAboutBluetoothPage({Key? key}) : super(key: key);

  @override
  _HomeAboutBluetoothPageState createState() => _HomeAboutBluetoothPageState();
}

class _HomeAboutBluetoothPageState extends State<HomeAboutBluetoothPage> {
  FlutterBluePlus _blueBT = FlutterBluePlus.instance;

  List itemsBlue = [];

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initCheck() async {
    itemsBlue.clear();

    _blueBT.scanResults.listen((results) {
      results.forEach((result) {
        if (!itemsBlue.contains(result.device.id.toString())) {
          setState(() {
            itemsBlue.add(result.device.toString());
          });
        }
      });
    });

    _blueBT.startScan(timeout: Duration(seconds: 3));
    _blueBT.stopScan();
  }

/*
  _initCheck2() async {
    itemsBlue.clear();
    _blueBT.startScan(timeout: Duration(seconds: 1));
    _blueBT.scanResults.listen((results) {
      if (results != null && results.length > 0) {
        for (var i = 0; i < results.length; i++) {
          print(results.length);
          print(results[i].device.toString());
          setState(() {
            itemsBlue.add(results[i].device.toString());
          });
        }
      }
      print(itemsBlue);
    });
  }
*/
/*  _initCheck3() async {
    itemsBlue.clear();
    _blueBT.startScan(timeout: Duration(seconds: 3));
    var subs = _blueBT.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
    _blueBT.stopScan();
  }
*/
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('flutter_blue_plus'),
          backgroundColor: rx_function.RexColors.AppBar,
          actions: <Widget>[
            IconButton(
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
        floatingActionButton: new Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: new Row(
            children: <Widget>[
              new FloatingActionButton(
                backgroundColor: rx_function.RexColors.AppBar,
                onPressed: () {
                  _initCheck();
                },
                child: Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: itemsBlue.length,
            itemBuilder: (context, i) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "BluePlus : " + itemsBlue[i],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
