import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../10_home.dart';
import '../00_standard/12_function.dart' as rx_function;

class DisplayImagePage extends StatefulWidget {
  final cImage;

  DisplayImagePage({this.cImage});

  @override
  _DisplayImagePageState createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image View"),
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
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.cImage),
        ),
      ),
    );
  }
}
