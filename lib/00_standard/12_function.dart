import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

String yLanguage = 'en';
String yCompanyCode = '';
String yEmployeeCode = '';
String yEmployeeName = '';

class RexString {}

class RexColors {
  static const AppBar = Color(0xFF0D47A1); // lightBlue[900]
  static const ButtonFrom = Color(0xFF1976D2); // Blue[700]
  static const ButtonTo = Color(0xFF1976D2); //Blue[700];
  static const ButtonActive = Color(0xFF00838F); //Cyan[800];
  static const ButtonText = Colors.white;
  static const ButtonReject = Color(0xFFC62828); // Colors.red[800];
  static const ButtonApprove = Color(0xFF2E7D32); //Colors.green[800];
  static const Icon = Color(0xFF00BCD4); //cyan;
  static const MenuFrom = Color(0xFF29B6F6); //lightBlue[400];
  static const MenuTo = Color(0xFF0288D1); //lightBlue[700];
  static const BackGround = Color(0xFFE0E0E0); //grey[300]
  static const Header = Color(0xFF2196F3); //blue;
  static const ViewDetail = Color(0xFFE65100); // orange[900]
  static const Card = Color(0xFFEEEEEE); // grey[200]
  static const Sorting = Color(0xFF90A4AE); // blueGrey[300]
}

class RexIcons {
  static const IconData icon_app = Icons.android;
  static const IconData icon_home = Icons.home;
}

class RexImages {
  static const String Img_logo = "assets/images/icon.png";
}

class RexTranslates {
  static const String Today = "{assets/images/icon.png";
}

Color get randomColor {
  List<Color> colors = [
    Colors.pink,
    Colors.green,
    Colors.lightBlue,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.brown,
    Colors.orange,
    Colors.cyan,
    Colors.grey,
    Colors.amber,
    Colors.blue,
    Colors.yellow,
    Colors.indigo,
    Colors.deepPurple,
    Colors.lime,
    Colors.deepOrange,
    Colors.lightGreen,
  ];
  return colors[Random().nextInt(colors.length)];
}

getText(String yParameter) {
  var yResult = '';

  getLanguage();

  _listTranslate.forEach(
    (data) {
      if (data['title'] == yParameter) {
        yResult = data[yLanguage] ?? "";
      }
    },
  );
  if (yResult == '') {
    yResult = yParameter;
  }
  return yResult;
}

getLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  yLanguage = prefs.getString('userlanguage').toString();
  yCompanyCode = prefs.getString('company_code').toString();
  yEmployeeCode = prefs.getString('employee_code').toString();
  yEmployeeName = prefs.getString('employee_name').toString();
}

List _listTranslate = [
// General
  {"title": "Company", "en": "Company", "id": "Perusahaan"},
  {"title": "Save", "en": "Save", "id": "Simpan"},
  {"title": "Delete", "en": "Delete", "id": "Hapus"},
  {"title": "Cancel", "en": "Cancel", "id": "Batal"},
  {"title": "Search", "en": "Search", "id": "Cari"},
  {"title": "Welcome", "en": "Welcome, ", "id": "Selamat Datang, "},
  {"title": "Description", "en": "Description", "id": "Keterangan"},
  {"title": "Old Password", "en": "Old Password", "id": "Password Lama"},
  {"title": "New Password", "en": "New Password", "id": "Password Baru"},
  {"title": "Retype", "en": "Retype", "id": "Ketik Ulang"},

// Date/Time
  {"title": "Daily", "en": "Daily", "id": "Harian"},
  {"title": "Monthly", "en": "Monthly", "id": "Bulanan"},
  {"title": "Weekly", "en": "Weekly", "id": "Mingguan"},
  {"title": "Yearly", "en": "Yearly", "id": "Tahunan"},
  {"title": "Date", "en": "Date", "id": "Tanggal"},
  {"title": "Dueate", "en": "Dueate", "id": "Jth Tempo"},
  {"title": "Monday", "en": "Monday", "id": "Senin"},
  {"title": "Tuesday", "en": "Tuesday", "id": "Selasa"},
  {"title": "Wednesday", "en": "Wednesday", "id": "Rabu"},
  {"title": "Thursday", "en": "Thursday", "id": "Kamis"},
  {"title": "Friday", "en": "Friday", "id": "Jumat"},
  {"title": "Saturday", "en": "Saturday", "id": "Sabtu"},
  {"title": "Sunday", "en": "Sunday", "id": "Minggu"},
  {"title": "From Date", "en": "From Date", "id": "dari Tanggal"},
  {"title": "To Date", "en": "To Date", "id": "s/d Tanggal"},
  {"title": "Period", "en": "Period", "id": "Periode"},
  {"title": "Day", "en": "Day", "id": "Hari"},
  {"title": "Time", "en": "Time", "id": "Waktu"},

// Employee
  {"title": "Name", "en": "Name", "id": "Nama"},
  {"title": "Code", "en": "Code", "id": "Kode"},
  {"title": "Division", "en": "Division", "id": "Divisi"},
  {"title": "Location", "en": "Location", "id": "Lokasi"},
  {"title": "Position", "en": "Position", "id": "Jabatan"},
  {"title": "BirthDate", "en": "Birth Date", "id": "Tanggal Lahir"},
  {"title": "BirthPlace", "en": "Birth Place", "id": "Tempat Lahir"},
  {"title": "Religion", "en": "Religion", "id": "Agama"},
  {"title": "Address", "en": "Address", "id": "Alamat"},
  {"title": "City", "en": "City", "id": "Kota"},
  {"title": "IdentityNo", "en": "Identity No", "id": "No KTP"},
  {"title": "IdentityAddress", "en": "Identity Address", "id": "Alamat KTP"},
  {"title": "IdentityCity", "en": "Identity City", "id": "Kota KTP"},
  {"title": "Employee ID", "en": "Employee ID", "id": "ID Karyawan"},
  {"title": "Company Code", "en": "Company Code", "id": "Kode Perusahaan"},
  {"title": "Mobile No", "en": "Mobile No", "id": "No HP"},

// Attendance
  {"title": "Attendance", "en": "Attendance", "id": "Absensi"},
  {"title": "Register", "en": "Register", "id": "Daftar"},
  {"title": "Employee Data", "en": "Employee Data", "id": "Data Karyawan"},
  {"title": "Header", "en": "Header", "id": "Judul"},
  {"title": "Take Photo", "en": "Take Photo", "id": "Lakukan Photo"},
  {"title": "Saving", "en": "Saving", "id": "Simpanan"},
  {"title": "Loan", "en": "Loan", "id": "Pinjaman"},
  {"title": "Balance", "en": "Balance", "id": "Saldo"},
  {"title": "Annual Leave", "en": "Annual Leave", "id": "Cuti"},
  {"title": "Sick Leave", "en": "Sick Leave", "id": "Sakit"},
  {"title": "Permit Leave", "en": "Permit Leave", "id": "Ijin"},
  {"title": "Revision", "en": "Revision", "id": "Revisi"},
  {"title": "Overtime", "en": "Overtime", "id": "Lembur"},
  {"title": "Choose", "en": "Choose", "id": "Pilih"},
  {"title": "Document", "en": "Document", "id": "Dokumen"},

// Sales
  {"title": "Receivable", "en": "Receivable", "id": "Piutang"},
  {"title": "Payable", "en": "Payable", "id": "Hutang"},
  {"title": "Sort Date", "en": "Sort Date", "id": "Urut Tanggal"},
  {"title": "Sort Name", "en": "Sort Name", "id": "Urut Nama"},
  {"title": "Sort Amount", "en": "Sort Amount", "id": "Urut Jumlah"},
  {"title": "Sort Qty", "en": "Sort Qty", "id": "Urut Qty"},
  {"title": "Price", "en": "Price", "id": "Harga"},
  {"title": "Amount", "en": "Amount", "id": "Jumlah"},
  {"title": "Warehouse", "en": "Warehouse", "id": "Gudang"},
  {"title": "Unit", "en": "Unit", "id": "Satuan"},
  {"title": "Brand", "en": "Brand", "id": "Merek"},

  {
    "title": "Data Not Found !!!",
    "en": "Data Not Found !!!",
    "id": "Tidak Ada Data !!!"
  },
  {
    "title": "Don\'t have an account ?",
    "en": "Don\'t have an account ?",
    "id": "Belum Punya Account?"
  },
  {
    "title": "Forgot Password ?",
    "en": "Forgot Password ?",
    "id": "Lupa Password?"
  },
  {
    "title": "DATA SAVED ...",
    "en": "DATA SAVED ...",
    "id": "DATA SUDAH DISIMPAN ..."
  },
  {
    "title": "DATA DELETED ...",
    "en": "DATA DELETED ...",
    "id": "DATA SUDAH DIHAPUS ..."
  },
  {
    "title": "Wait for Approval",
    "en": "Wait for Approval",
    "id": "Tunggu Persetujuan"
  },
  {
    "title": "No Image Selected",
    "en": "No Image Selected",
    "id": "Tidak Ada Photo"
  },
];
