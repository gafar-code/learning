import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

import '257_saleskanvas_customer_info.dart';
import '257_saleskanvas_customer_sales.dart';

class SalesKanvasTransactionPage extends StatefulWidget {
  @override
  _SalesKanvasTransactionPageState createState() =>
      _SalesKanvasTransactionPageState();
}

class _SalesKanvasTransactionPageState
    extends State<SalesKanvasTransactionPage> {
  String _entryCustomer = '';
  String cGroupPrice = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Transaction'),
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
      backgroundColor: rx_customs.RexColors.BackGround,
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardCustomer(context),
                _cardBlank(context),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.00,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  CategoryCard(
                    Icons.home,
                    'Customer' + '\n' + 'Info',
                    () => {
                      _entryCustomer == ''
                          ? {}
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SalesKanvasCustomerInfoPage(
                                  cCustomer: _entryCustomer,
                                ),
                              ),
                            )
                    },
                  ),
                  CategoryCard(
                      Icons.settings,
                      'Sales',
                      () => {
                            _entryCustomer == ''
                                ? {}
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SalesKanvasCustomerSalesPage(
                                        cCustomer: _entryCustomer,
                                      ),
                                    ),
                                  )
                          }),
                  CategoryCard(
                    Icons.settings,
                    'Receivable',
                    () => {_entryCustomer == '' ? {} : {}},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardCustomer(BuildContext context) {
    return Expanded(
      flex: 6,
      child: SizedBox(
        height: 70,
        child: GestureDetector(
          onTap: () {
            _showModalProject(context);
          },
          child: Card(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Customer",
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
                    _entryCustomer,
                    style: TextStyle(
                        fontSize: 16,
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

  _showModalProject(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 75 / 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          child: SalesKanvasCustomerInfoPage(),
        );
      },
    ).whenComplete(() => _initCheck());
  }

  Widget _cardBlank(BuildContext context) {
    return Expanded(
      flex: 6,
      child: SizedBox(
        height: 70,
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _entryCustomer = prefs.getString('temp_customer') != null
        ? prefs.getString('temp_customer').toString()
        : '';
    cGroupPrice = prefs.getString('temp_groupprice') != null
        ? prefs.getString('temp_groupprice').toString()
        : 'RETAIL';

    setState(() => isLoading = false);
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
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Colors.lightBlue,
            ),
          ],
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
                    style: TextStyle(color: Colors.black, fontSize: 12),
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
