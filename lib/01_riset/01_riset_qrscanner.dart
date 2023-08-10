import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;

class HomeAboutQRScannerPage extends StatefulWidget {
  const HomeAboutQRScannerPage({Key? key}) : super(key: key);

  @override
  State<HomeAboutQRScannerPage> createState() => _HomeAboutQRScannerPageState();
}

class _HomeAboutQRScannerPageState extends State<HomeAboutQRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  String cMessage = "Scan a Code";
  String cResult = 'Scanning';

  bool isLoading = false;
  bool isScanQRCode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
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
      body: Container(
        child: Column(
          children: <Widget>[
            isScanQRCode
                ? Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      overlay: QrScannerOverlayShape(borderRadius: 10),
                      onQRViewCreated: (QRViewController controller) {
                        _scanData(controller);
                      },
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: cResult == 'Scanning'
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            children: [
                              Icon(
                                Icons.check_box_rounded,
                                color: Colors.green,
                                size: 100,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Scan Success",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                cResult,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              !isLoading
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isScanQRCode = true;
                                          cMessage = "Scan a code";
                                        });
                                      },
                                      child: Text("Re-Scan"))
                                  : SizedBox(),
                            ],
                          ),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> _scanData(controller) async {
    controller.scannedDataStream.listen((res) async {
      var value = res.code;
      setState(() {
        cMessage = 'Data Scanned';
        cResult = value;
        isScanQRCode = false;
      });
      return;
    });
  }
}
