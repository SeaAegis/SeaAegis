import 'package:flutter/material.dart';

// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: const Color(0xFF0277BD),
//   scaffoldBackgroundColor: const Color(0xFFFFFFFF),
//   colorScheme: const ColorScheme.light(
//     primary: Color(0xFF0277BD),
//     secondary: Color(0xFF80DEEA),
//     surface: Color(0xFFE1F5FE),
//     error: Color(0xFFD32F2F),
//     onPrimary: Colors.white,
//     onSecondary: Colors.white,
//     onSurface: Color(0xFF000000),
//     onError: Colors.white,
//   ),
// );

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF1E88E5), // Ocean Blue
  hintColor: const Color(0xFF29B6F6), // Light Sky Blue

  cardColor: const Color(0xFF81D4FA), // Soft Aqua
  scaffoldBackgroundColor: const Color(0xFFE3F2FD), // Light Cloudy Blue

  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF29B6F6), // Light Sky Blue
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF1E88E5), // Ocean Blue
  ),
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 76, 162, 237), // Ocean Blue
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ), // Coral Alert Orange
  dividerColor: const Color(0xFFB3E5FC),
  colorScheme:
      const ColorScheme.light(error: Color(0xFFFF7043)), // Light Blue Divider
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF0288D1),
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0288D1),
    secondary: Color(0xFF26C6DA),
    surface: Color(0xFF263238),
    error: Color(0xFFEF5350),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Color(0xFFFFFFFF),
    onError: Colors.black,
  ),
);
