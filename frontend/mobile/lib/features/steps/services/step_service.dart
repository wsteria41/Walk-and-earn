import '../../../core/api/api_service.dart';
import '../../../core/constants/api_constants.dart';

class StepService {

  final ApiService api = ApiService();

  Future<void> syncSteps(int totalSteps) async {
    try {

      final response = await api.post(
        ApiConstants.syncSteps,
        {
          "totalSteps": totalSteps
        },
      );

      print("Steps synced: $response");

    } catch (e) {

      print("STEP SYNC ERROR: $e");

    }
  }

}