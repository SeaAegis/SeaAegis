import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF0277BD),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0277BD),
    secondary: Color(0xFF80DEEA),
    surface: Color(0xFFE1F5FE),
    error: Color(0xFFD32F2F),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF000000),
    onError: Colors.white,
  ),
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
