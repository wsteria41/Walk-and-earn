import 'package:flutter/material.dart';
import 'app_text.dart';

class LanguageController extends ChangeNotifier {

  void setLanguage(String lang){

    AppText.currentLang = lang;

    notifyListeners();
  }

}