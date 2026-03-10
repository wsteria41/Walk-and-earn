import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'step_service.dart';

class StepManager {//Buh alhaltiin logic

  final StepService stepService = StepService();

  StreamSubscription<StepCount>? _subscription;

  int _lastSyncedSteps = 0;
  int _currentSteps = 0;

  void startTracking() {

    _subscription = Pedometer.stepCountStream.listen((StepCount event) {

      _currentSteps = event.steps;

      print("Current Steps: $_currentSteps");

    });
  }

  void stopTracking() {
    _subscription?.cancel();
  }

  Future<void> syncSteps() async {

    if (_currentSteps == 0) return;

    if (_currentSteps == _lastSyncedSteps) return;

    await stepService.syncSteps(_currentSteps);

    _lastSyncedSteps = _currentSteps;

  }

}