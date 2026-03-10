
import '../../../core/api/api_service.dart';
import '../../../core/constants/api_constants.dart';

class StepService {// Step sync service

  final ApiService api = ApiService();

  Future<void> syncSteps(int totalSteps) async {

    await api.post(
      ApiConstants.syncSteps,
      {
        "totalSteps": totalSteps
      }
    );

  }

}