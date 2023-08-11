import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:learning/10_listing/106_listing_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../00_standard/12_function.dart' as rx_function;
import '../widgets/dots_divider.dart';

class ListingPrinter extends StatefulWidget {
  const ListingPrinter({super.key});

  @override
  State<ListingPrinter> createState() => _ListingPrinterState();
}

class _ListingPrinterState extends State<ListingPrinter> {
  final controller = ScreenshotController();
  int total = 0;

  @override
  Widget build(BuildContext context) {
    for (var data in transactionOne.product) {
      total += data.priceProduct * data.totalOrderProduct;
    }

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      appBar: AppBar(
        backgroundColor: rx_function.RexColors.AppBar,
        title: const Text("105. Listing Printer"),
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: controller,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Center(
                  child: _buildStoreAddress(
                    titleStore: transactionOne.nameStore,
                    addresStore: transactionOne.addresStore,
                  ),
                ),
                _buildDateAndSales(
                  salesStore: transactionOne.nameSalesStore,
                  dateStore: formatDateTimeInWIB(transactionOne.createAt),
                  noTrasaction: transactionOne.noTrasactionStore,
                  timeStore: "${formatTimeInWIB(transactionOne.createAt)} WIB",
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactionOne.product.length,
                  itemBuilder: (context, index) {
                    final data = transactionOne.product[index];

                    return _buildOrderTransaction(
                      index: index,
                      nameProduct: data.nameProduct,
                      priceProduct: data.priceProduct,
                      totalOrderProduct: data.totalOrderProduct,
                    );
                  },
                ),
                _buildPayment(
                  changeMoney: transactionOne.pay - total,
                  pay: transactionOne.pay,
                  total: total,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void printAction() {}

  void shareWAAction() async {
    final image =
        await controller.capture(delay: const Duration(milliseconds: 5));
    if (image != null) {
      await saveAndShare(image);
    } else {}
  }

  void downloadAction() async {
    final image =
        await controller.capture(delay: const Duration(milliseconds: 5));
    if (image != null) {
      await saveImage(image);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Screenshot downloaded successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture screenshot')),
      );
    }
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/transaction.png');
    image.writeAsBytesSync(bytes);
    final text = 'Shared From ';
    await Share.shareFiles([image.path], text: text);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "transaction_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }

  String formatCurrency(int amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatCurrency.format(amount);
  }

  String formatTimeInWIB(DateTime dateTime) {
    // Convert to WIB (UTC +7) by adding 7 hours
    dateTime = dateTime.add(const Duration(hours: 7));

    // Format the time in WIB
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }

  String formatDateTimeInWIB(DateTime dateTime) {
    // Convert to WIB (UTC +7) by adding 7 hours
    dateTime = dateTime.add(const Duration(hours: 7));

    // Format the date and time in WIB
    String formattedDateTime = DateFormat(
      'dd/MMM/yyyy',
    ).format(dateTime);

    return formattedDateTime;
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
                "${formatCurrency(totalOrderProduct * priceProduct)}",
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

  Container _buildFloatingActionButton() {
    return Container(
      padding: EdgeInsets.only(left: 80, bottom: 10),
      child: Row(
        children: [
          FloatingActionButton(
            onPressed: printAction,
            tooltip: 'Print',
            child: const Icon(Icons.print),
          ),
          const SizedBox(width: 40),
          FloatingActionButton(
            onPressed: shareWAAction,
            tooltip: 'Share WA',
            child: const Icon(Icons.share),
          ),
          const SizedBox(width: 40),
          FloatingActionButton(
            onPressed: downloadAction,
            tooltip: 'Download',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Column _buildLine() {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Column _buildPayment({
    required int total,
    required int pay,
    required int changeMoney,
  }) {
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
            const Text("Total"),
            Text(
              "${formatCurrency(total)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text("Bayar"),
        //     Text("${formatCurrency(pay)}"),
        //   ],
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text("Kembali"),
        //     Text("${formatCurrency(changeMoney)}"),
        //   ],
        // ),
        const SizedBox(
          height: 10,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 2,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Terima Kasih",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        BarcodeWidget(data: '123456789', barcode: Barcode.qrCode()),
        const SizedBox(
          height: 10,
        ),
        const DotsDivider(),
        const SizedBox(
          height: 10,
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pluit, Penjaringan"),
              Text("Norh Jakarta City,14450")
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Transaction {
  final String nameStore;
  final String addresStore;
  final String nameSalesStore;
  final String noTrasactionStore;
  final DateTime createAt;
  final List<Product> product;
  final int pay;

  Transaction({
    required this.nameStore,
    required this.pay,
    required this.addresStore,
    required this.createAt,
    required this.nameSalesStore,
    required this.noTrasactionStore,
    required this.product,
  });
}

Transaction transactionOne = Transaction(
  pay: 30000000,
  nameStore: "nameStore",
  addresStore: "addresStore",
  createAt: DateTime.now(),
  nameSalesStore: "nameSalesStore",
  noTrasactionStore: "ASDFPOIU09",
  product: [
    Product(
        nameProduct: "Asinan Sayur", priceProduct: 30000, totalOrderProduct: 2),
    Product(nameProduct: "Air", priceProduct: 30000, totalOrderProduct: 1),
    Product(
        nameProduct: "Handpone", priceProduct: 4000000, totalOrderProduct: 3),
  ],
);

class Product {
  final String nameProduct;
  final int priceProduct;
  final int totalOrderProduct;

  Product({
    required this.nameProduct,
    required this.priceProduct,
    required this.totalOrderProduct,
  });
}
