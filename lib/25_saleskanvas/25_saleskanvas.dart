import 'package:flutter/material.dart';

import '../10_home.dart';
import '../00_standard/11_home_drawer.dart';
import '../00_standard/12_function.dart' as rx_function;
import '../00_customs/10_customs.dart' as rx_customs;

import '257_saleskanvas_customer.dart';

class SalesKanvasPage extends StatefulWidget {
  @override
  _SalesKanvasPageState createState() => _SalesKanvasPageState();
}

class _SalesKanvasPageState extends State<SalesKanvasPage> {
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
        title: Text('Sales Kanvas'),
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
      drawer: HomeDrawer(),
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: [
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
                    Icons.home,
                    'Transaction',
                    () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesKanvasCustomerPage(),
                        ),
                      )
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

  Future _initCheck() async {}
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
          color: rx_customs.RexColors.GridColor,
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
                    color: rx_customs.RexColors.GridIcon,
                    size: 30,
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
