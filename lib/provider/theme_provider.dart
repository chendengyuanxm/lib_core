import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  MaterialColor _primaryColor = Colors.blue;
  MaterialColor get primaryColor => _primaryColor;
  set primaryColor(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }

  MaterialAccentColor _accentColor = Colors.blueAccent;
  MaterialAccentColor get accentColor => _accentColor;
  set accentColor(MaterialAccentColor color) {
    _accentColor = color;
    notifyListeners();
  }

  setPrimaryColor(MaterialColor color) {
    this._primaryColor = color;
    notifyListeners();
  }
}