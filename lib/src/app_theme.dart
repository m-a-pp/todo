import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme(bool isDark) {
    final theme = isDark
        ? ThemeData(
      brightness: Brightness.dark,
    )
        : ThemeData(
      textTheme: const TextTheme(
        headline1: TextStyle(
            color: Color(0xFF000000),
            height: 32 / 38,
            fontWeight: FontWeight.w500,
            fontSize: 32),
        headline3: TextStyle(
            color: Color(0xFF000000),
            height: 32 / 38,

            fontWeight: FontWeight.w500,
            fontSize: 20),
        headline2: TextStyle(
            color: Color(0x4D000000),
            height: 20 / 32,
            fontWeight: FontWeight.w400,
            fontSize: 16),
        bodyText1: TextStyle(
            color: Color(0xFF000000),
            height: 32 / 20,
            fontWeight: FontWeight.w400,
            fontSize: 16),
        bodyText2: TextStyle(
            color: Color(0xFFFF3B30),
            height: 20 / 32,
            fontWeight: FontWeight.w400,
            fontSize: 16
        ),
        headline4: TextStyle(
            color: Color(0x4D000000),
            height: 32 / 20,
            fontWeight: FontWeight.w400,
            fontSize: 16,
            decoration: TextDecoration.lineThrough,
        ),
      ),
      brightness: Brightness.light,
      primaryColor: const Color(0xFFF7F6F2),
      cardColor: Colors.white,
      secondaryHeaderColor: Colors.blue,
      indicatorColor: const Color(0xFF34C759),
      fontFamily: 'Roboto',
      dividerTheme: const DividerThemeData(
        color: Color(0x33000000),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(size: 24),
    );
    return theme;
    //.copyWith(
    //);
  }
}
