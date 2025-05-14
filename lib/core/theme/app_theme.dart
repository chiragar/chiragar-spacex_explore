import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey[900],
      colorScheme: ColorScheme.light(
        primary: Colors.blueGrey[900]!,
        secondary: Colors.deepOrangeAccent,
        background: Colors.grey[200]!,
        surface: Colors.white,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.black,
      ),
      textTheme: _textTheme(Brightness.light),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.tealAccent[700],
      colorScheme: ColorScheme.dark(
        primary: Colors.tealAccent[700]!,
        secondary: Colors.amberAccent,
        background: Colors.grey[900]!,
        surface: Colors.grey[850]!,
        error: Colors.red,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: Colors.white,
        onSurface: Colors.white,
        onError: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
      ),
      textTheme: _textTheme(Brightness.dark),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[800],
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final textColor = brightness == Brightness.light ? Colors.black87 : Colors.white;
    return TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, color: textColor),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
    );
  }
}