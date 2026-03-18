import 'package:flutter/material.dart';

class AppTheme {

  //WARNA DASAR DARI DESAIN KAMU
  static const Color primaryColor = Color(0xFF8AB0AB);
  static const Color pressedColor = Color(0xFF3E505B);
  static const Color darkBg = Colors.black;
  static const Color gradientGreen = Color(0xFF26413C);

  // LIGHT MODE
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Raleway",

    scaffoldBackgroundColor: Colors.black,

    colorScheme: ColorScheme.light(
      primary: primaryColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),

      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),

      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      bodySmall: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  // DARK MODE
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Raleway",

    scaffoldBackgroundColor: darkBg,

    colorScheme: ColorScheme.dark(
      primary: primaryColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
     textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),

      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),

      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      bodySmall: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w500,
      ),
    ),

  );
}