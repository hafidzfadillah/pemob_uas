import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xFF0C57AF);
const accentColor = Color(0xFF24A4DD);
const blackColor = Color(0xFF333333);

const urlPlaceholder =
    'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
const imgPlaceholder = 'assets/images/placeholder.png';

String priceFormat(double price) {
  return NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(price);
}
