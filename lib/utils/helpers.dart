 import 'package:intl/intl.dart';
 
 String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: '');
    return formatCurrency.format(amount);
  }
