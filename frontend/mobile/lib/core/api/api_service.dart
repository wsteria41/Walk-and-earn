import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class ApiService {
  final SecureStorage storage = SecureStorage();

  //GET request
  Future<http.Response> get(String endpoint) async {
    final token = await storage.getToken();

    print("TOKEN FROM STORAGE: $token");
    print("REQUEST URL: ${ApiConstants.baseUrl + endpoint}");

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    return await http.get(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: headers,
    );
  }

  //POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
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

  //PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final token = await storage.getToken();

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    return await http.put(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  //DASHBOARD DATA
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await get(ApiConstants.dashboard);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load dashboard: ${response.body}");
  }

  //UPDATE GOAL
  Future<void> updateGoal(int newGoal) async {
    final response = await post(ApiConstants.updateGoal, {"goal": newGoal});

    if (response.statusCode != 200) {
      throw Exception("Goal update failed: ${response.body}");
    }
  }

  //DAILY STATS
  Future<List<dynamic>> getDailyStats() async {
    final response = await get("/users/stats/daily?days=7");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map && data.containsKey("stats")) {
        return List.from(data["stats"]);
      }

      return [];
    }

    print("API ERROR: ${response.body}");
    return [];
  }

  //PROFILE DATA
  Future<Map<String, dynamic>> getProfile() async {
    final response = await get("/users/profile");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load profile");
  }

  //TOTAL STATS (Steps, streak, rewards)
  Future<Map<String, dynamic>> getTotalStats() async {
    final response = await get("/users/stats/total");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load total stats");
  }

Future<void> updateProfile(Map<String, dynamic> data) async {
  final response = await put("/users/profile", data);

  if (response.statusCode != 200) {
    throw Exception("Profile update failed");
  }
}

Future<void> updateHealth(Map<String, dynamic> data) async {
  final response = await put("/users/health", data);

  if (response.statusCode != 200) {
    throw Exception("Health update failed");
  }
}

}
