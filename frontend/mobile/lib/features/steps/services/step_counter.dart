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

      await _readSteps(onStep);
    }

    Future<void> _readSteps(Function(int) onStep) async {
      try {
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);

        int? steps = await health.getTotalStepsInInterval(midnight, now);

        if (steps == null) {
          final data = await health.getHealthDataFromTypes(
            types: [HealthDataType.STEPS],
            startTime: midnight,
            endTime: now,
          );
          steps = data.fold(0, (sum, d) => sum! + (d.value as num).toInt());
        }

        _steps = steps ?? 0;
        log.i("TODAY STEPS: $_steps");
        onStep(_steps);
      } catch (e) {
        log.e("STEP ERROR", error: e);
      }
    }
  }