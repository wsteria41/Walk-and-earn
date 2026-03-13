import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'step_permission.dart';

class StepCounter {

  int _steps = 0;

  int get currentSteps => _steps;

  final Health health = Health();

  final Logger log = Logger();

  Future<void> startListening(Function(int) onStep) async {

    bool granted = await StepPermission.request();

    if (!granted) {
      log.w("Permission denied");
      return;
    }

    try {

      final types = [
        HealthDataType.STEPS,
      ];

      bool requested = await health.requestAuthorization(types);

      if (!requested) {
        log.w("Health permission denied");
        return;
      }

      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: types,
      );

      int totalSteps = 0;

      for (var point in healthData) {
        totalSteps += (point.value as num).toInt();
      }

      _steps = totalSteps;

      log.i("TODAY STEPS: $_steps");

      onStep(_steps);

    } catch (e) {

      log.e("STEP ERROR", error: e);

    }
  }
}