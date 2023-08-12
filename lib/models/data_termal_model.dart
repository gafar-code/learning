class DataThermalModel {
    final String name;
    final String province;
    final String sales;
    final String codeSales;
    final String date;
    final String time;
    final List<Item> items;
    final String qrcode;
    final String address;

    DataThermalModel({
        required this.name,
        required this.province,
        required this.sales,
        required this.codeSales,
        required this.date,
        required this.time,
        required this.items,
        required this.qrcode,
        required this.address,
    });

    factory DataThermalModel.fromJson(Map<String, dynamic> json) => DataThermalModel(
        name: json["name"],
        province: json["province"],
        sales: json["sales"],
        codeSales: json["code_sales"],
        date: json["date"],
        time: json["time"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        qrcode: json["qrcode"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "province": province,
        "sales": sales,
        "code_sales": codeSales,
        "date": date,
        "time": time,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "qrcode": qrcode,
        "address": address,
    };
}

class Item {
    final String name;
    final int quantity;
    final int price;

    Item({
        required this.name,
        required this.quantity,
        required this.price,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "price": price,
    };
}
