import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {

  Locale _locale = const Locale("en");

  Locale get locale => _locale;

  void setLanguage(String code) {
    _locale = Locale(code);
    notifyListeners();
  }

}