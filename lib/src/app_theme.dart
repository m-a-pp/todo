import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
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
          fontSize: 16),
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
    highlightColor: const Color(0x33FFFFFF),
    hoverColor: const Color(0xFFFFFFFF),
    fontFamily: 'Roboto',
    dividerTheme: const DividerThemeData(
      color: Color(0x33000000),
      thickness: 1,
    ),
    iconTheme: const IconThemeData(size: 24),
  );
  static ThemeData darkTheme = ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: Color(0xFFFFFFFF),
          height: 32 / 38,
          fontWeight: FontWeight.w500,
          fontSize: 32),
      headline3: TextStyle(
          color: Color(0xFFFFFFFF),
          height: 32 / 38,
          fontWeight: FontWeight.w500,
          fontSize: 20),
      headline2: TextStyle(
          color: Color(0x66FFFFFF),
          height: 20 / 32,
          fontWeight: FontWeight.w400,
          fontSize: 16),
      bodyText1: TextStyle(
          color: Color(0xFFFFFFFF),
          height: 32 / 20,
          fontWeight: FontWeight.w400,
          fontSize: 16),
      bodyText2: TextStyle(
          color: Color(0xFFFF3B30),
          height: 20 / 32,
          fontWeight: FontWeight.w400,
          fontSize: 16),
      headline4: TextStyle(
        color: Color(0x66FFFFFF),
        height: 32 / 20,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        decoration: TextDecoration.lineThrough,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF161618),
    cardColor: const Color(0xFF252528),
    secondaryHeaderColor: Colors.blue,
    indicatorColor: const Color(0xFF34C759),
    highlightColor: const Color(0x33FFFFFF),
    hoverColor: const Color(0xFFFFFFFF),
    fontFamily: 'Roboto',
    dividerTheme: const DividerThemeData(
      color: Color(0x33000000),
      thickness: 1,
    ),
    iconTheme: const IconThemeData(size: 24),
  );


}
