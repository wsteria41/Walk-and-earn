import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider(){
    loadLanguage();
  }

  void setLanguage(String code) async {
    _locale = Locale(code);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", code);

    notifyListeners();
  }

  void loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    String code = prefs.getString("language") ?? "en";
    _locale = Locale(code);

    notifyListeners();
  }

}