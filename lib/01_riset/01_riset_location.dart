import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../10_home.dart';
import '../00_standard/12_language.dart';
import '../00_standard/12_function.dart' as rx_function;

class HomeAboutLocationPage extends StatefulWidget {
  @override
  _HomeAboutLocationPageState createState() => _HomeAboutLocationPageState();
}

class _HomeAboutLocationPageState extends State<HomeAboutLocationPage> {
  String cEmployeeImage = '';
  String cLanguage = '';

  String lat = "";
  String long = "";

  String cLocality = "";
  String cSubLocality = "";
  String cAdministrativeArea = "";
  String cSubAdministrativeArea = "";
  String cCountry = "";
  String cPostalCode = "";
  String cIsoCountryCode = "";
  String cThoroughfare = "";
  String cSubThoroughfare = "";
  String cName = "";
  String cStreet = "";

  List dataJSON = [];
  bool isLoading = false;

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
        title: Text("Geo Location"),
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
        child: isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView(
                children: <Widget>[
                  SizedBox(height: 10),
                  _listProfile1(),
                  SizedBox(height: 10),
                  _listProfile2(),
                  SizedBox(height: 200),
                ],
              ),
      ),
    );
  }

  Widget _listProfile1() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildHeader('Geo Location'),
          _buildDivider(),
          _buildList('Latitude', lat, false),
          _buildList('Longitude', long, false),
        ],
      ),
    );
  }

  Widget _listProfile2() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildHeader('Location'),
          _buildDivider(),
          _buildList('Country', cCountry, false),
          _buildList('Country Code', cIsoCountryCode, false),
          _buildList('Admin Area', cAdministrativeArea, false),
          _buildList('SubAdmin Area', cSubAdministrativeArea, false),
          _buildList('Locality', cLocality, false),
          _buildList('SubLocality', cSubLocality, false),
//          _buildList('Thoroughfare', cThoroughfare, false),
//          _buildList('Sub Thoroughfare', cSubThoroughfare, false),
          _buildList('Postal Code', cPostalCode, false),
          _buildList('Name', cName, false),
          _buildList('Street', cStreet, false),
        ],
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    await Geolocator.requestPermission();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude.toString();
      long = position.longitude.toString();

      try {
        List<Placemark> newPlace;
        newPlace = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark placeMark = newPlace[0];
        cLocality = placeMark.locality.toString();
        cSubLocality = placeMark.subLocality.toString();
        cAdministrativeArea = placeMark.administrativeArea.toString();
        cSubAdministrativeArea = placeMark.subAdministrativeArea.toString();
        cCountry = placeMark.country.toString();
        cPostalCode = placeMark.postalCode.toString();
        cIsoCountryCode = placeMark.isoCountryCode.toString();
        cThoroughfare = placeMark.thoroughfare.toString();
        cSubThoroughfare = placeMark.subThoroughfare.toString();
        cName = placeMark.name.toString();
        cStreet = placeMark.street.toString();
      } catch (e) {
        cLocality = '.';
        cSubLocality = '.';
        cAdministrativeArea = '.';
        cSubAdministrativeArea = '.';
        cCountry = '.';
        cPostalCode = '.';
        cIsoCountryCode = '.';
        cThoroughfare = '.';
        cSubThoroughfare = '.';
        cName = '.';
        cStreet = '.';
      }
    } catch (e) {
      lat = '.';
      long = '.';
    }

//    List<Placemark> newPlace =
//        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() => isLoading = false);
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      width: double.infinity,
      height: 3.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildHeader(cHeader) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(height: 10, width: 20),
          Container(
            child: Text(
              cHeader,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildList(cHeader, cName, isChange) {
    if (cName == null) {
      cName = '';
    }

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  setLanguage(cHeader, cLanguage),
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  cName != null ? cName : '.',
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            width: double.infinity,
            height: 1.0,
            color: Colors.grey.shade200,
          )
        ],
      ),
    );
  }
}
