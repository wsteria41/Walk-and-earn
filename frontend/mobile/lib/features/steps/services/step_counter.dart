import 'package:pedometer/pedometer.dart';
import 'step_permission.dart';

class StepCounter {

  int _steps = 0;

  int get currentSteps => _steps;

  Future<void> startListening(Function(int) onStep) async {

    bool granted = await StepPermission.request();

    if (!granted) {
      print("Permission denied");
      return;
    }

    try {

      Pedometer.stepCountStream.listen((StepCount event) {

        _steps = event.steps;

        print("STEP EVENT: $_steps");

        onStep(_steps); // callback → frontend эсвэл API sync

      });

    } catch (e) {

      print("STEP ERROR: $e");

    }

  }

}