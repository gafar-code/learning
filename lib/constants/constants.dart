import 'package:learning/models/data_termal_model.dart';

// ======= DATA JSON ========
// {
//     "name":"PT. MERAPI MAJU MAKMUR",
//     "province": "JAKARTA",
//     "sales": "Agus",
//     "code_sales":"AGS: 00012/23080",
//     "date": "08/Agt/2023",
//     "time":"10:23",
//     "items":[
//         {
//             "name":"Lemari 2 Pintu",
//             "quantity": 10,
//             "price":15000
//         },
//         {
//             "name":"Kursi Lebar",
//             "quantity": 5,
//             "price":7000
//         },
//         {
//             "name":"Kunci",
//             "quantity": 1,
//             "price":5000
//         },
//         {
//             "name":"Tambahan",
//             "quantity": 1,
//             "price":1200000
//         }
//     ],
//     "qrcode":"WQibdfsinw",
//     "address": "Pluit, Penjaringan North Jakarta City, 14450"
// }

final DataThermalModel dataDummy = DataThermalModel(
  name: "PT. MERAPI MAJU MAKMUR",
  province: "JAKARTA",
  sales: "Agus",
  codeSales: "AGS: 00012/23080",
  date: "08/Agt/2023",
  time: "10:23",
  items: [
    Item(name: "Lemari 2 Pintu", quantity: 10, price: 15000),
    Item(name: "Kursi lebar", quantity: 5, price: 35000),
    Item(name: "Kunci", quantity: 1, price: 5000),
    Item(name: "Tambahan", quantity: 1, price: 1200000),
  ],
  qrcode: "WQibdfsinw",
  address: "Pluit, Penjaringan North Jakarta City, 14450",
);


