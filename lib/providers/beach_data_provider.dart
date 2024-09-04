import 'package:flutter/material.dart';

class BeachDataProvider extends ChangeNotifier {
  int _selectedIndex = 1;
  DateTime today = DateTime.now();
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
