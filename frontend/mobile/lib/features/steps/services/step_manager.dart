import 'dart:async';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';

import 'step_permission.dart';
import 'step_service.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

      if (!granted) return false;

      // restart хийсний дараах pending sync
      await _syncPendingIfOnline();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
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

      final steps = await _health.getTotalStepsInInterval(midnight, now);

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

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final isOnline = await _hasInternet();

      if (!isOnline) {
        await savePendingSteps(
          _currentSteps,
          position.latitude,
          position.longitude,
        );

        _log.w("OFFLINE — хадгаллаа");
        return;
      }

      final pending = await getPendingSteps();

      if (pending["steps"] > 0) {
        await _stepService.syncSteps(
          pending["steps"],
          pending["lat"],
          pending["lng"],
        );

        await clearPendingSteps();

        _log.i("PENDING SYNC DONE");
      }

      await _stepService.syncSteps(
        _currentSteps,
        position.latitude,
        position.longitude,
      );

      _log.i("SYNCED TOTAL: $_currentSteps");
    } catch (e) {
      _log.e("SYNC ERROR", error: e);
    }
  }

  Future<void> _syncPendingIfOnline() async {
    try {
      final isOnline = await _hasInternet();

      if (!isOnline) return;

      final pending = await getPendingSteps();

      if (pending["steps"] == 0) return;

      await _stepService.syncSteps(
        pending["steps"],
        pending["lat"],
        pending["lng"],
      );

      await clearPendingSteps();

      _log.i("Pending synced after restart");
    } catch (e) {
      _log.e("Pending sync error", error: e);
    }
  }

  Future<void> savePendingSteps(int steps, double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("pendingSteps", steps);
    await prefs.setDouble("pendingLat", lat);
    await prefs.setDouble("pendingLng", lng);
  }

  Future<Map<String, dynamic>> getPendingSteps() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "steps": prefs.getInt("pendingSteps") ?? 0,
      "lat": prefs.getDouble("pendingLat"),
      "lng": prefs.getDouble("pendingLng"),
    };
  }

  Future<void> clearPendingSteps() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("pendingSteps");
    await prefs.remove("pendingLat");
    await prefs.remove("pendingLng");
  }

  Future<bool> _hasInternet() async {
    //internet check function
    try {
      final result = await InternetAddress.lookup("google.com");

      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
