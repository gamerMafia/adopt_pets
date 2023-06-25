import 'package:flutter/material.dart';
import 'package:pets_adopt/utility/colors.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColor.darkBrownColor,
    cardTheme: const CardTheme().copyWith(
      color: AppColor.cardBackground,
    ),
    appBarTheme: const AppBarTheme()
        .copyWith(color: Colors.white, foregroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    hintColor: AppColor.hintBrownColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: AppColor.buttonBrownColor,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: AppColor.darkBrownColor,
      cardTheme: const CardTheme().copyWith(
        color: AppColor.cardDarkBackground,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
        backgroundColor: AppColor.cardDarkBackground,
        foregroundColor: Colors.white,
      ));
}
