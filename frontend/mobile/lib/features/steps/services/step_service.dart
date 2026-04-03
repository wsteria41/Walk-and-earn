import 'dart:convert';
import '../../../core/api/api_service.dart';
import '../../../core/constants/api_constants.dart';
import 'package:logger/logger.dart';

class StepService {
  final ApiService _api = ApiService();
  final Logger _log = Logger();

  Future<void> syncSteps(
    int totalSteps,
    double latitude,
    double longitude,
  ) async {
    try {
      _log.i("SYNC REQUEST → totalSteps: $totalSteps, lat: $latitude, lng: $longitude");

      final response = await _api.post(
        ApiConstants.syncSteps,
        {
          "totalSteps": totalSteps,
          "latitude": latitude,
          "longitude": longitude,
        },
      );

      _log.i("SYNC RESPONSE status: ${response.statusCode}");
      _log.i("SYNC RESPONSE body: ${response.body}");
    } catch (e) {
      _log.e("STEP SYNC ERROR: $e");
    }
  }

  Future<int> getDailyGoal() async {
    try {
      final response = await _api.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final goal = data["daily_goal"] ?? 10000;
        _log.i("DAILY GOAL: $goal");
        return goal;
      }

      return 10000; 
    } catch (e) {
      _log.e("GET DAILY GOAL ERROR: $e");
      return 10000; 
    }
  }
}