import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black), // Couleur du texte en mode clair
      bodyText2: TextStyle(color: Colors.black), // Couleur du texte en mode clair
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white), // Couleur du texte en mode sombre
      bodyText2: TextStyle(color: Colors.white), // Couleur du texte en mode sombre
    ),
  );

  void toggleTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }
}
