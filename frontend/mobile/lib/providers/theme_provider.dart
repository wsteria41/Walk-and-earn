import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme(bool value) async {

    _themeMode = value ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", value);

    notifyListeners();
  }

  void loadTheme() async {

    final prefs = await SharedPreferences.getInstance();

    bool? dark = prefs.getBool("darkMode");

    if (dark != null) {
      _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
}