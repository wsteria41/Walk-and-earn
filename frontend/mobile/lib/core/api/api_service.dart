import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class ApiService {//api service class backend server-ruu request hiih heseg

  final SecureStorage storage = SecureStorage();

  //get request
  Future<http.Response> get(String endpoint) async {
    final token = await storage.getToken();

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    return await http.get(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: headers,
    );
  }

  //post request
  Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
    final token = await storage.getToken();

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    return await http.post(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  //dashboard data avah request
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await get("/dashboard");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load dashboard data: ${response.body}");
    }
  }

  //profile data avah request
  Future<Map<String, dynamic>> getProfile() async {
    final response = await get("/profile");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile data: ${response.body}");
    }
  }

  
}