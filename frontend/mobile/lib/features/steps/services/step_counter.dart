import 'package:pedometer/pedometer.dart';

class StepCounter {

  Stream<StepCount> getStepStream() {
    return Pedometer.stepCountStream;
  }

}