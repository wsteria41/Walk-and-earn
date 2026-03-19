import 'dart:async';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:mobile/features/steps/services/step_permission.dart';
import 'step_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';

class StepManager {
  final StepService stepService = StepService();
  final Health health = Health();
  final Logger log = Logger();

  Timer? _timer;
  int _lastSyncedSteps = 0;
  int _currentSteps = 0;

  int get currentSteps => _currentSteps;
  Function(int)? onStepUpdate;

  // ✅ HEALTH PERMISSION FIX
  Future<bool> _ensureHealthPermission() async {
    try {
      final sdkStatus = await health.getHealthConnectSdkStatus();

      if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
        log.w("Health Connect not available → installing...");
        await health.installHealthConnect();
        return false;
      }

      bool granted = await health.requestAuthorization(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ],
      );

      log.i("HEALTH PERMISSION RESULT: $granted");

      if (!granted) return false;

      // ✅ test read (хамгийн найдвартай шалгалт)
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      await health.getTotalStepsInInterval(midnight, now);

      log.i("Health permission confirmed ✅");
      return true;
    } catch (e) {
      log.e("Health permission error", error: e);
      return false;
    }
  }

  Future<void> startTracking() async {
  try {
    _timer?.cancel();

    // 1. basic permission
    bool granted = await StepPermission.request();
    if (!granted) return;

    log.i("Health permission OK ");

    _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      await _readSteps();
    });

  } catch (e) {
    log.e("START ERROR", error: e);
  }
}
  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    log.i("Step tracking stopped");
  }
Future<void> _readSteps() async {
  try {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    int? steps = await health.getTotalStepsInInterval(midnight, now);

    if (steps == null) {
      log.w("getTotalSteps null → fallback");

final data = await health.getHealthDataFromTypes(
  types: [HealthDataType.STEPS],
  startTime: midnight,
  endTime: now,
);

      int total = 0;
      for (var d in data) {
        total += (d.value as num).toInt();
      }

      steps = total;
    }

    _currentSteps = steps ?? 0;
    log.i("FINAL STEPS: $_currentSteps");

  } catch (e) {
    log.e(e);
  }
}

  Future<void> syncSteps() async {
    await _readSteps();

    if (_currentSteps == 0) {
      log.w("SYNC SKIPPED: steps is 0");
      return;
    }

    if (_currentSteps - _lastSyncedSteps < 5) {
      log.d("SYNC SKIPPED: diff too small (${_currentSteps - _lastSyncedSteps})");
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
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

  Future<void> syncTodayFromHealth() async {
    await _readSteps();
    await syncSteps();
  }
}