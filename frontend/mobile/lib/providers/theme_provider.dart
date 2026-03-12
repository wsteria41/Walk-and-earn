import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  bool _darkMode = true;

  bool get isDark => _darkMode;

  ThemeMode get themeMode => _darkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider(){
    loadTheme();
  }

  void toggleTheme(bool value) async {
    _darkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", value);

    notifyListeners();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _darkMode = prefs.getBool("darkMode") ?? true;

    notifyListeners();
  }
}