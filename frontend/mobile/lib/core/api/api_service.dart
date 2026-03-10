import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class ApiService { // API request hiij backend server-ruu holbogdoh class 

  final SecureStorage storage = SecureStorage();

  Future<http.Response> get(String endpoint) async {

    final token = await storage.getToken();

    return await http.get(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {

    final token = await storage.getToken();

    return await http.post(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
  }

}