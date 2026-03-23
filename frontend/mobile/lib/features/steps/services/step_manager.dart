import 'dart:async';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';

import 'step_permission.dart';
import 'step_service.dart';

class StepManager {
  final Health _health = Health();
  final Logger _log = Logger();
  final StepService _stepService = StepService();

  Timer? _timer;

  int _currentSteps = 0;
  int _lastSyncedSteps = 0;

  int get currentSteps => _currentSteps;

  Function(int)? onStepUpdate;

  Future<bool> startTracking() async {
    try {
      _timer?.cancel();

      final granted = await StepPermission.request();
      if (!granted) {
        _log.e("Permission NOT granted");
        return false;
      }

      _log.i("Tracking started ");
      _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
        await _readSteps();
      });

      return true;
    } catch (e) {
      _log.e("START ERROR", error: e);
      return false;
    }
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    _log.i("Tracking stopped");
  }

  Future<int> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      return await _health.getTotalStepsInInterval(midnight, now) ?? 0;
    } catch (e) {
      _log.e("GET TODAY STEPS ERROR", error: e);
      return 0;
    }
  }

  Future<void> _readSteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      int? steps = await _health.getTotalStepsInInterval(midnight, now);

      _currentSteps = steps ?? 0;
      onStepUpdate?.call(_currentSteps);
      _log.i("STEPS: $_currentSteps");
    } catch (e) {
      _log.e("READ ERROR: $e");
    }
  }

  Future<void> syncSteps() async {
    try {
      await _readSteps();

      if (_currentSteps == 0) {
        _log.w("SYNC SKIPPED: 0 steps");
        return;
      }

      if (_currentSteps - _lastSyncedSteps < 5) {
        _log.d("SYNC SKIPPED: diff too small");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _stepService.syncSteps(
        _currentSteps,
        position.latitude,
        position.longitude,
      );

      _lastSyncedSteps = _currentSteps;
      _log.i("SYNCED: $_currentSteps");
    } catch (e) {
      _log.e("SYNC ERROR", error: e);
    }
  }
}
