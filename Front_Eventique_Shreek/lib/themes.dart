import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = const Color.fromRGBO(243, 218, 255, 1);
  Color darkPrimaryColor = const Color.fromRGBO(38, 34, 38, 1);
  Color secondaryColor = const Color.fromRGBO(77, 4, 81, 1);
  Color accentColor = const Color.fromRGBO(244, 142, 196, 1);
  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themeClass.lightPrimaryColor,
      secondary: _themeClass.secondaryColor,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
      secondary: _themeClass.secondaryColor,
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
