import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:learning/01_riset/01_riset_bluetooth_thermal_printer.dart';
import 'package:learning/models/data_termal_model.dart';
import 'package:learning/utils/helpers.dart';
// import 'package:learning/10_listing/106_listing_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../00_standard/12_function.dart' as rx_function;
import '../widgets/dots_divider.dart';

class ShowPrinterData extends StatefulWidget {
  const ShowPrinterData({
    super.key,
    required this.data,
  });

  final DataThermalModel data;

  @override
  State<ShowPrinterData> createState() => _ShowPrinterDataState();
}

class _ShowPrinterDataState extends State<ShowPrinterData> {
  final controller = ScreenshotController();
  late int total;

  @override
  void initState() {
    total = 0;
    for (Item element in widget.data.items) {
      total += (element.price * element.quantity);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: rx_function.RexColors.AppBar,
        title: const Text("01. show data"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          children: [
            Screenshot(
              controller: controller,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Center(
                      child: _buildStoreAddress(
                        titleStore: widget.data.name,
                        addresStore: widget.data.province,
                      ),
                    ),
                    _buildDateAndSales(
                      salesStore: widget.data.sales,
                      dateStore: widget.data.date,
                      noTrasaction: widget.data.codeSales,
                      timeStore: widget.data.time,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.data.items.length,
                      itemBuilder: (context, index) {
                        return _buildOrderTransaction(
                          index: index,
                          nameProduct: widget.data.items[index].name,
                          priceProduct: widget.data.items[index].price,
                          totalOrderProduct: widget.data.items[index].quantity,
                        );
                      },
                    ),
                    _buildPayment(total: total),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: printAction,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "PRINT",
                        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold, shadows: [
                          Shadow(color: Colors.black.withOpacity(.8), offset: Offset(1, 2), blurRadius: 7),
                        ]),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: shareWAAction,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "WA",
                        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold, shadows: [
                          Shadow(color: Colors.black.withOpacity(.8), offset: Offset(1, 2), blurRadius: 7),
                        ]),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "EXIT",
                        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold, shadows: [
                          Shadow(color: Colors.black.withOpacity(.8), offset: Offset(1, 2), blurRadius: 7),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void printAction() {
    Navigator.of(context).push(MaterialPageRoute(builder: (c) => RisetBluettothThermalPrinterPage(data: widget.data)));
  }

  void shareWAAction() async {
    final image = await controller.capture(delay: const Duration(milliseconds: 5));
    if (image != null) {
      await saveAndShare(image);
    }
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/transaction.png');
    image.writeAsBytesSync(bytes);
    final text = 'laporan_${widget.data.codeSales}';
    await Share.shareFiles([image.path], text: text);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now().toIso8601String().replaceAll('.', '_').replaceAll(':', '_');
    final name = "transaction_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }

  Column _buildOrderTransaction({
    required String nameProduct,
    required int priceProduct,
    required int totalOrderProduct,
    required int index,
  }) {
    index += 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$index',
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  nameProduct,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$totalOrderProduct x ${formatCurrency(priceProduct)}"),
              Text(
                formatCurrency(totalOrderProduct * priceProduct),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column _buildDateAndSales({
    required String salesStore,
    required String noTrasaction,
    required String dateStore,
    required String timeStore,
  }) {
    return Column(
      children: [
        const DotsDivider(),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sales: $salesStore"),
                Text(noTrasaction),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(dateStore),
                Text(timeStore),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Keterangan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Jumlah",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column _buildStoreAddress({
    required String titleStore,
    required String addresStore,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          titleStore,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          addresStore,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column _buildPayment({required int total}) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 5,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "TOTAL",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              formatCurrency(total),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const DotsDivider(height: .1),
        const SizedBox(
          height: 2,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 28,
        ),
        const Text(
          "Terima Kasih",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        BarcodeWidget(data: widget.data.qrcode, barcode: Barcode.qrCode()),
        const SizedBox(
          height: 10,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 200,
            child: Text(
              widget.data.address,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
