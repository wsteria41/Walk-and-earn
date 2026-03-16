import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class ApiService {
  final SecureStorage storage = SecureStorage();
  final Logger log = Logger();

  //GET request
  Future<http.Response> get(String endpoint) async {
    final token = await storage.getToken();

    log.i("TOKEN FROM STORAGE: $token");
    log.i("REQUEST URL: ${ApiConstants.baseUrl}$endpoint");

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    return await http.get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
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

    log.i("DASHBOARD STATUS: ${response.statusCode}");
    log.d("DASHBOARD BODY: ${response.body}");

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
  Future<List<Map<String, dynamic>>> getDailyStats() async {
    final response = await get("/users/stats/daily?days=7");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<Map<String, dynamic>>.from(data["dailyStats"]);
    }

    throw Exception("Failed to load daily stats");
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

  Future<Map<String, dynamic>> getHealth() async {
    final response = await get("/users/health");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // backend structure check
      if (data.containsKey("health")) {
        return data["health"];
      }

      return data;
    }

    throw Exception("Failed to load health data");
  }

  Future<String> uploadProfilePhoto(File file) async {
    final token = await storage.getToken();

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiConstants.baseUrl}/users/profile/photo")
    );

    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    request.files.add(await http.MultipartFile.fromPath("photo", file.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      return data["photo"] ?? data["profile_photo"];
    } else {
      throw Exception("Photo upload failed: ${res.body}");
    }
  }

  //SYNC STEPS
  Future<Map<String, dynamic>> syncSteps(
    int totalSteps,
    double latitude,
    double longitude,
  ) async {
    final response = await post("/users/sync-steps", {
      "totalSteps": totalSteps,
      "latitude": latitude,
      "longitude": longitude,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Step sync failed: ${response.body}");
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final response = await get("/walk/history?days=7");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<Map<String, dynamic>>.from(data["history"] ?? []);
    }

    throw Exception("Failed to load history");
  }

Future<List<Map<String, dynamic>>> getRewardList() async {
  final response = await get("/rewards/list");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data["rewards"] ?? []);
  }

  throw Exception("Failed to load rewards");
}

Future<List<Map<String, dynamic>>> getMyRedemptions() async {
  final response = await get("/rewards/my-redemptions");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data["redemptions"] ?? []);
  }

  throw Exception("Failed to load redemptions");
}

Future<Map<String, dynamic>> redeemReward(int rewardId) async {
  final response = await post("/rewards/redeem/$rewardId", {});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception(jsonDecode(response.body)["error"] ?? "Redeem failed");
}
}
