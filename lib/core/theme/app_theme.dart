import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 93, 26, 176); // Deep Purple
  static const Color secondaryColor1 = Color(0xFF6A1B9A); // Rich Violet
  static const Color secondaryColor2 = Color(0xFFFFC67D); // Deep Coral
  static const Color accentColor = Color(0xFFF7DC6F); // Bright Sunshine Yellow
  static const Color backgroundColor = Color(0xFFF7F7F7); // Soft Gray-Beige

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontSize: 18),
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
    ),
  );
}
