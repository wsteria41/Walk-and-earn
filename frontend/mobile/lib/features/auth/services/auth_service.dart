import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/storage/secure_storage.dart';

class AuthService {
  final SecureStorage storage = SecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data["token"];

        if (token != null) {
          await storage.saveToken(token);
        }

        return true;
      }

      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.register),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }
}