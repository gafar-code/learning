import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../10_home.dart';
import '../00_standard/11_home_drawer.dart';
import '../00_standard/12_function.dart' as rx_function;
import '101_listing_header.dart';
import '102_listing_simple.dart';
import '103_listing_employee.dart';
import '104_listing_document.dart';

class ListingPage extends StatefulWidget {
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  DateTime dateTimeNow =
      DateTime.utc(DateTime.now().year, DateTime.now().month, 01);
  String _entryFromPeriod =
      DateFormat('MMM-yyyy').format(DateTime.utc(DateTime.now().year, 01, 01));
  String _entryToPeriod = DateFormat('MMM-yyyy')
      .format(DateTime.utc(DateTime.now().year, DateTime.now().month, 01));
  String _entryCompany = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing'),
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
                    'Header',
                    () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingHeaderPage()))
                    },
                  ),
                  CategoryCard(
                    Icons.image_rounded,
                    'simple',
                    () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingSimplePage(
                                    dateTimeFrom: _entryFromPeriod,
                                    dateTimeTo: _entryToPeriod,
                                    cCompany: _entryCompany,
                                    cHeader: 'Salesman',
                                  )))
                    },
                  ),
                  CategoryCard(
                    Icons.book_rounded,
                    'employee',
                    () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingEmployeePage()))
                    },
                  ),
                  CategoryCard(
                      Icons.chat_bubble_rounded,
                      'Document',
                      () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListingDocumentPage()))
                          }),
                  CategoryCard(
                    Icons.contact_phone,
                    'Contact',
                    () => {},
                  ),
                  CategoryCard(Icons.notifications, 'Notification', () => {}),
                  CategoryCard(
                    Icons.library_add_check_rounded,
                    'Document' + '\n' + 'Print Address',
                    () => {},
                  ),
                  CategoryCard(
                    Icons.attach_money,
                    'Koperasi',
                    () => {},
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
