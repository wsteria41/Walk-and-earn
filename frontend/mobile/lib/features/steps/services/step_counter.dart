import 'package:pedometer/pedometer.dart';

class StepCounter {

  Future<int> getTodaySteps() async {
    int steps = 0;

    Stream<StepCount> stepStream = Pedometer.stepCountStream;

    await stepStream.first.then((event) {
      steps = event.steps;
    });

    return steps;
  }
}