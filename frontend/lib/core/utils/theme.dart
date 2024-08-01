import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  useMaterial3: true,
  fontFamily: ThemeOptions.font,
);

class ThemeOptions {
  static String get font => "Poppins";
}

abstract class AppColors {
  static const primary = Color(0xFF3B76F6);
  static const secondary = Color(0xFF3B76F6);
  static const blueLight = Color(0xFF29ADFF);
  static const purple = Color(0xFFA020F0);
  static const pink = Color(0xFFC50043);
  static const accent = Color(0xFFD6755B);
  static const textDark = Color(0xFF53585A);
  static const textLight = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const textFadedBlue = Color(0xFFCCCCFF);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0x91000000);
}
