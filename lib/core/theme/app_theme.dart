import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color.fromARGB(255, 93, 26, 176);
  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color lightAccent = Color(0xFFF7DC6F); 
  
  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFBB86FC);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkAccent = Color(0xFF03DAC6); 

  // Make colors context-aware (optional)
  static Color primaryColor(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? darkPrimary : lightPrimary;
  
  static Color accentColor(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? darkAccent : lightAccent;
  
  static Color backgroundColor(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? darkBackground : lightBackground;

  // Theme Data
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      secondary: lightAccent,
      surface: lightBackground,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: _textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkAccent,
      surface: darkBackground,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: _textTheme,
  );

  static const TextTheme _textTheme = TextTheme(
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
  );
}