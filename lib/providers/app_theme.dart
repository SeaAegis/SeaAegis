import 'package:flutter/material.dart';
import 'package:seaaegis/helpers/dark_mode.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(BuildContext context) {
    print(context.isDarkMode);
    _themeMode = context.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    print(themeMode);

    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;

    notifyListeners();
  }
}
