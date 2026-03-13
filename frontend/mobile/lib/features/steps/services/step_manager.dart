import 'dart:async';
import 'package:health/health.dart';
import 'step_service.dart';
import 'step_permission.dart';

class StepManager {

  final StepService stepService = StepService();
  final HealthFactory health = HealthFactory();

  Timer? _timer;

  int _lastSyncedSteps = 0;
  int _currentSteps = 0;

  int get currentSteps => _currentSteps;

  /// START TRACKING
  Future<void> startTracking() async {

    bool granted = await StepPermission.request();

    if (!granted) {
      print("Activity recognition permission denied");
      return;
    }

    try {

      final types = [
        HealthDataType.STEPS,
      ];

      bool requested = await health.requestAuthorization(types);

      if (!requested) {
        print("Health permission denied");
        return;
      }

      /// 10 секунд тутам алхалт шалгана
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {

        await _readSteps();

      });

    } catch (e) {

      print("STEP TRACK ERROR: $e");

    }

  }

  /// STOP TRACKING
  void stopTracking() {
    _timer?.cancel();
  }

  /// HEALTH DATA АВАХ
  Future<void> _readSteps() async {

    try {

      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> data =
          await health.getHealthDataFromTypes(
        midnight,
        now,
        [HealthDataType.STEPS],
      );

      int totalSteps = 0;

      for (var point in data) {
        totalSteps += (point.value as num).toInt();
      }

      _currentSteps = totalSteps;

      print("TODAY STEPS: $_currentSteps");

    } catch (e) {

      print("READ STEP ERROR: $e");

    }

  }

  /// SERVER SYNC
  Future<void> syncSteps() async {

    if (_currentSteps == 0) return;

    if (_currentSteps == _lastSyncedSteps) return;

    try {

      await stepService.syncSteps(_currentSteps);

      _lastSyncedSteps = _currentSteps;

      print("STEPS SYNCED: $_currentSteps");

    } catch (e) {

      print("SYNC ERROR: $e");

    }

  }

}