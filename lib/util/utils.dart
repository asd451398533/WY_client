import 'package:flutter/material.dart';

class Utils {
  static String getImagePath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String formatDouble(double toFormat) {
    return (toFormat * 10) % 10 != 0 ? "$toFormat" : "${toFormat.toInt()}";
  }
}
