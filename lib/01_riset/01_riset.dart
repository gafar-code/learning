import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/01_riset/01_show_data.dart';
import 'package:learning/constants/constants.dart';

import '../10_home.dart';
import '../00_standard/11_home_drawer.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

import '01_riset_location.dart';
import '01_riset_qrscanner.dart';
import '01_riset_blue_thermal_printer.dart';
import '01_riset_deviceinfo.dart';
import '01_riset_bluetooth_blueplus.dart';
import '01_riset_bluetooth_print.dart';
import '01_riset_bluetooth_thermal_printer.dart';

class RisetPage extends StatefulWidget {
  @override
  _RisetPageState createState() => _RisetPageState();
}

class _RisetPageState extends State<RisetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riset'),
        backgroundColor: rx_customs.RexColors.BarColor,
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
      drawer: HomeDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.00,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  CategoryCard(
                    Icons.corporate_fare_rounded,
                    'Device Info',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAboutDeviceInfoPage())),
                  ),
                  CategoryCard(
                    Icons.image_rounded,
                    'Flutter' + '\n' + 'Blue Plus',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAboutBluetoothPage())),
                  ),
                  CategoryCard(
                    Icons.settings,
                    'Geo Location',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAboutLocationPage())),
                  ),
                  CategoryCard(
                    Icons.library_add_check_rounded,
                    'Barcode' + '\n' + 'Scanner',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAboutQRScannerPage())),
                  ),
                  CategoryCard(
                    Icons.library_add_check_rounded,
                    'Blue Thermal' + '\n' + 'Printer',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => RisetBlueThermalPrinterPage())),
                  ),
                  CategoryCard(
                    Icons.library_add_check_rounded,
                    'Bluetooth' + '\n' + 'Print',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => RisetBluettothPrintPage())),
                  ),
                  CategoryCard(
                    Icons.library_add_check_rounded,
                    'Bluetooth Thermal' + '\n' + 'Printer',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowPrinterData(
                                    data: dataDummy,
                                  ))),
                  ),
                  // CategoryCard(
                  //   Icons.library_add_check_rounded,
                  //   'Barcode' + '\n' + 'Print2',
                  //   () => {Navigator.push(context, MaterialPageRoute(builder: (context) => RisetQRGeneratorPrint2()))},
                  // ),
                  // CategoryCard(
                  //   Icons.library_add_check_rounded,
                  //   'Barcode' + '\n' + 'Print3',
                  //   () => {Navigator.push(context, MaterialPageRoute(builder: (context) => RisetQRGeneratorPrint3()))},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData cardIcon;
  final String cardText;
  final GestureTapCallback cardOnTap;

  CategoryCard(
    this.cardIcon,
    this.cardText,
    this.cardOnTap,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: cardOnTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Icon(
                    cardIcon,
                    color: Colors.lightBlueAccent[700],
                    size: 25,
                  ),
                  Spacer(),
                  Text(
                    cardText,
                    style: GoogleFonts.nunito().copyWith(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
