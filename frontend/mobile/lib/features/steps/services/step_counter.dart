import 'package:health/health.dart';
import 'step_permission.dart';

class StepCounter {

  int _steps = 0;

  int get currentSteps => _steps;

  final HealthFactory health = HealthFactory();

  Future<void> startListening(Function(int) onStep) async {

    bool granted = await StepPermission.request();

    if (!granted) {
      print("Permission denied");
      return;
    }

    try {

      //ymar turliin health data 
      final types = [
        HealthDataType.STEPS,
      ];

      //permission avna
      bool requested = await health.requestAuthorization(types);

      if (!requested) {
        print("Health permission denied");
        return;
      }

      //unuudriin 00:00
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day);

      //health data avah
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(
        midnight,
        now,
        types,
      );

      int totalSteps = 0;

      for (var point in healthData) {
        totalSteps += (point.value as num).toInt();
      }

      _steps = totalSteps;

      print("TODAY STEPS: $_steps");

      //callback → UI / API sync
      onStep(_steps);

    } catch (e) {

      print("STEP ERROR: $e");

    }
  }
}