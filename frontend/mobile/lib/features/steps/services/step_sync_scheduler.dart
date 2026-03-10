import 'dart:async';
import 'step_manager.dart';

class StepSyncScheduler {//Auto sync timer

  final StepManager manager;

  Timer? _timer;

  StepSyncScheduler(this.manager);

  void start() {

    _timer = Timer.periodic(
      const Duration(seconds: 60),
      (timer) async {

        await manager.syncSteps();

      },
    );

  }

  void stop() {
    _timer?.cancel();
  }

}