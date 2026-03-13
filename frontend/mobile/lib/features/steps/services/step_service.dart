import '../../../core/api/api_service.dart';
import '../../../core/constants/api_constants.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class StepService {

  final ApiService api = ApiService();

  Future<void> syncSteps(
    int totalSteps,
    double latitude,
    double longitude,
  ) async {

    try {

      final response = await api.post(
        ApiConstants.syncSteps,
        {
          "totalSteps": totalSteps,
          "latitude": latitude,
          "longitude": longitude
        },
      );

      log.i("Steps synced: $response");

    } catch (e) {

      log.i("STEP SYNC ERROR: $e");

    }
  }

}