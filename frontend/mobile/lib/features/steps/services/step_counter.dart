import 'package:pedometer/pedometer.dart';
import 'step_permission.dart';

class StepCounter {

  Future<int> getTodaySteps() async {

    bool granted = await StepPermission.request();

    if (!granted) {
      print("Permission denied");
      return 0;
    }

    try {

      StepCount event = await Pedometer.stepCountStream.first;

      return event.steps;

    } catch (e) {

      print("STEP ERROR: $e");

      return 0;

    }

  }

}