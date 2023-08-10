import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../10_home.dart';
import '../00_standard/11_home_drawer.dart';
import '../00_standard/12_function.dart' as rx_function;
import '401_map_marker.dart';
import '402_map_line.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
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
                    'Map Marker',
                    () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Map_MarkerPage()))
                    },
                  ),
                  CategoryCard(
                    Icons.corporate_fare_rounded,
                    'Map Line',
                    () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Map_LinePage()))
                    },
                  ),
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
