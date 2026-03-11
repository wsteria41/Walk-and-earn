import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'step_service.dart';
import 'step_permission.dart';

class StepManager {

  final StepService stepService = StepService();

  StreamSubscription<StepCount>? _subscription;

  int _lastSyncedSteps = 0;
  int _currentSteps = 0;

  // STEP TRACKING START
  Future<void> startTracking() async {

    bool granted = await StepPermission.request();

    if (!granted) {
      print("Activity recognition permission denied");
      return;
    }

    _subscription = Pedometer.stepCountStream.listen(
      (StepCount event) {

        _currentSteps = event.steps;

        print("Current Steps: $_currentSteps");

      },
      onError: (error) {
        print("Step sensor error: $error");
      },
    );
  }

  // STOP TRACKING
  void stopTracking() {
    _subscription?.cancel();
  }

  // SYNC STEPS TO SERVER
  Future<void> syncSteps() async {

    if (_currentSteps == 0) return;

    if (_currentSteps == _lastSyncedSteps) return;

    await stepService.syncSteps(_currentSteps);

    _lastSyncedSteps = _currentSteps;

  }

}