import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {

  bool _enabled = true;

  bool get enabled => _enabled;

  NotificationProvider(){
    loadNotification();
  }

  void toggle(bool value) async {

    _enabled = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);

    notifyListeners();
  }

  void loadNotification() async {

    final prefs = await SharedPreferences.getInstance();

    _enabled = prefs.getBool("notifications") ?? true;

    notifyListeners();
  }

}