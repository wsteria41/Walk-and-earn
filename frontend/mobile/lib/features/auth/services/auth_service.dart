import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/secure_storage.dart';

class AuthService {

  final SecureStorage storage = SecureStorage();
  final Logger log = Logger();

  Future<bool> login(String email, String password) async {

    try {

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.login}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      log.i("LOGIN STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];

        if (token != null) {
          await storage.saveToken(token);
          log.i("TOKEN SAVED");

          return true;
        }
      }

      log.w("LOGIN FAILED");
      return false;

    } catch (e) {
      log.e("LOGIN ERROR", error: e);
      
      return false;

    }
  }

  Future<bool> register(String name, String email, String password) async {

    try {

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.register}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        }),
      );

      log.i("REGISTER STATUS: ${response.statusCode}");
    

      return response.statusCode == 200 || response.statusCode == 201;

    } catch (e) {

      log.e("REGISTER ERROR", error: e);

      return false;

    }
  }
}