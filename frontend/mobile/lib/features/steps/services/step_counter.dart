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
      log.w("Activity permission denied");
      return;
    }

    try {
final types = [HealthDataType.STEPS];
final permissions = [HealthDataAccess.READ];

// ⚠️ Шууд permission хүс
bool requested = await health.requestAuthorization(
  types,
  permissions: permissions,
);

if (!requested) {
  log.w("Health permission denied");
  return;
}

      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      int? steps = await health.getTotalStepsInInterval(midnight, now);

      _steps = steps ?? 0;
      log.i("TODAY STEPS: $_steps");
      onStep(_steps);
    } catch (e) {
      log.e("STEP ERROR", error: e);
    }
  }
}