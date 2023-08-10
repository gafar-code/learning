import 'package:device_info_plus/device_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import '../10_home.dart';
import '../00_standard/12_language.dart';
import '../00_customs/10_customs.dart' as rx_customs;
import '../00_standard/12_function.dart' as rx_function;

class HomeAboutDeviceInfoPage extends StatefulWidget {
  @override
  _HomeAboutDeviceInfoPageState createState() =>
      _HomeAboutDeviceInfoPageState();
}

class _HomeAboutDeviceInfoPageState extends State<HomeAboutDeviceInfoPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String cSecurityPatch = '';
  String cSdkInt = '';
  String cRelease = '';
  String cPreviewSdkInt = '';
  String cIncremental = '';
  String cCodeName = '';
  String cBaseOS = '';
  String board = '';
  String brand = '';
  String device = '';
  String hardware = '';
  String host = '';
  String id = '';
  String manufacture = '';
  String model = '';
  String product = '';
  String type = '';
  String androidid = '';
  String deviceId = '';
  String platformid = '';
  String displaySizeInches = '';
  String displayWidthPixels = '';
  String displayWidthInches = '';
  String displayHeightPixels = '';
  String displayHeightInches = '';
  String displayXDpi = '';
  String displayYDpi = '';
  String cAppName = '';
  String cVersion = '';
  String cPackageName = '';
  String cBuildNumber = '';

  bool isphysicaldevice = true;

  String cLanguage = '';
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
        title: Text('Device Info'),
        backgroundColor: rx_customs.RexColors.BarColor,
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
      backgroundColor: rx_customs.RexColors.BackGround,
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
                  const SizedBox(height: 10),
                  _listProfile1(),
                  SizedBox(height: 10),
                  _listProfile2(),
                  SizedBox(height: 10),
                  _listProfile3(),
                  SizedBox(height: 10),
                  _listProfile4(),
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
          _buildHeader('VERSION'),
/*          Container(
            padding: EdgeInsets.all(10),
            width: 800,
            height: 40,
            decoration: BoxDecoration(
              color: rx_customs.RexColors.ButtonActive,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Text(
              'VERSION',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
*/
//          _buildDivider(),
          _buildList('securityPatch', cSecurityPatch, false),
          _buildList('sdkInt', cSdkInt, false),
          _buildList('release', cRelease, false),
          _buildList('previewSdkInt', cPreviewSdkInt, false),
          _buildList('incremental', cIncremental, false),
          _buildList('codename', cCodeName, false),
          _buildList('baseOS', cBaseOS, false),
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
          _buildHeader('Device'),
          _buildDivider(),
          _buildList('board', board, false),
          _buildList('brand', brand, false),
          _buildList('device', device, false),
          _buildList('hardware', hardware, false),
          _buildList('host', host, false),
          _buildList('id', id, false),
          _buildList('manufacture', manufacture, false),
          _buildList('model', model, false),
          _buildList('product', product, false),
          _buildList('type', type, false),
        ],
      ),
    );
  }

  Widget _listProfile3() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildHeader('Display'),
          _buildDivider(),
          _buildList('SizeInches', displaySizeInches, false),
          _buildList('WidthPixels', displayWidthPixels, false),
          _buildList('WidthInches', displayWidthInches, false),
          _buildList('HeightPixels', displayHeightPixels, false),
          _buildList('HeightInches', displayHeightInches, false),
          _buildList('XDpi', displayXDpi, false),
          _buildList('YDpi', displayYDpi, false),
        ],
      ),
    );
  }

  Widget _listProfile4() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildHeader('Platform Device'),
          _buildDivider(),
          _buildList('device', platformid, false),
          _buildList('app name', cAppName, false),
          _buildList('package name', cPackageName, false),
          _buildList('version', cVersion, false),
          _buildList('build number', cBuildNumber, false),
        ],
      ),
    );
  }

  Future _initCheck() async {
    setState(() => isLoading = true);

    var deviceId2 = await PlatformDeviceId.getDeviceId;
    platformid = deviceId2.toString();

    AndroidDeviceInfo androidDeviceInfo;
    androidDeviceInfo = await deviceInfo.androidInfo;
    setState(() {
      cSecurityPatch = androidDeviceInfo.version.securityPatch.toString();
      cSdkInt = androidDeviceInfo.version.sdkInt.toString();
      cRelease = androidDeviceInfo.version.release.toString();
      cPreviewSdkInt = androidDeviceInfo.version.previewSdkInt.toString();
      cIncremental = androidDeviceInfo.version.incremental.toString();
      cCodeName = androidDeviceInfo.version.codename.toString();
      cBaseOS = androidDeviceInfo.version.baseOS.toString();
      board = androidDeviceInfo.board.toString();
      brand = androidDeviceInfo.brand.toString();
      device = androidDeviceInfo.device.toString();
      hardware = androidDeviceInfo.hardware.toString();
      host = androidDeviceInfo.host.toString();
      id = androidDeviceInfo.id.toString();
      manufacture = androidDeviceInfo.manufacturer.toString();
      model = androidDeviceInfo.model.toString();
      product = androidDeviceInfo.product.toString();
      type = androidDeviceInfo.type.toString();
      isphysicaldevice = androidDeviceInfo.isPhysicalDevice;
      displaySizeInches =
          ((androidDeviceInfo.displayMetrics.sizeInches * 10).roundToDouble() /
                  10)
              .toString();
      displayWidthPixels = androidDeviceInfo.displayMetrics.widthPx.toString();
      displayWidthInches =
          androidDeviceInfo.displayMetrics.widthInches.toString();
      displayHeightPixels =
          androidDeviceInfo.displayMetrics.heightPx.toString();
      displayHeightInches =
          androidDeviceInfo.displayMetrics.heightInches.toString();
      displayXDpi = androidDeviceInfo.displayMetrics.xDpi.toString();
      displayYDpi = androidDeviceInfo.displayMetrics.yDpi.toString();
    });

    PackageInfo.fromPlatform().then(
      (PackageInfo packageInfo) {
        cAppName = packageInfo.appName;
        cPackageName = packageInfo.packageName;
        cVersion = packageInfo.version;
        cBuildNumber = packageInfo.buildNumber;
      },
    );
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
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 45,
      decoration: BoxDecoration(
        color: rx_customs.RexColors.CardHeader,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Text(
        cHeader,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.left,
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
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
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
