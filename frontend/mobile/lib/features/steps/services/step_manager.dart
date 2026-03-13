import 'dart:async';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'step_service.dart';
import 'step_permission.dart';
import 'package:geolocator/geolocator.dart';

class StepManager {
  final StepService stepService = StepService();
  final Health health = Health();

  final Logger log = Logger();

  Timer? _timer;

  int _lastSyncedSteps = 0;
  int _currentSteps = 0;

  int get currentSteps => _currentSteps;

  /// START TRACKING
  Future<void> startTracking() async {
    bool granted = await StepPermission.request();

    if (!granted) {
      log.w("Activity recognition permission denied");
      return;
    }

    try {
      final types = [HealthDataType.STEPS];

      bool requested = await health.requestAuthorization(types);

      if (!requested) {
        log.w("Health permission denied");
        return;
      }

      /// 10 секунд тутам алхалт шалгана
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        await _readSteps();
      });

      log.i("Step tracking started");
    } catch (e) {
      log.e("STEP TRACK ERROR", error: e);
    }
  }

  void stopTracking() {
    _timer?.cancel();

    log.i("Step tracking stopped");
  }

  Future<void> _readSteps() async {
    try {
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> data = await health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.STEPS],
      );

      int totalSteps = 0;

      for (var point in data) {
        totalSteps += (point.value as num).toInt();
      }

      _currentSteps = totalSteps;

      log.d("TODAY STEPS: $_currentSteps");
    } catch (e) {
      log.e("READ STEP ERROR", error: e);
    }
  }

Future<void> syncSteps() async {

  if (_currentSteps == 0) return;

  if (_currentSteps == _lastSyncedSteps) return;

  try {

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await stepService.syncSteps(
      _currentSteps,
      position.latitude,
      position.longitude,
    );

    _lastSyncedSteps = _currentSteps;

    log.i("STEPS SYNCED: $_currentSteps");

  } catch (e) {

    log.e("SYNC ERROR", error: e);

  }

}
}
