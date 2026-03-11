import 'dart:async';
import 'step_manager.dart';

class StepSyncScheduler {

  final StepManager manager;

  Timer? _timer;

  StepSyncScheduler(this.manager);

  void start() {

    if (_timer != null) return;

    _timer = Timer.periodic(
      const Duration(seconds: 60),
      (timer) async {

        await manager.syncSteps();

      },
    );

  }

  void stop() {

    _timer?.cancel();
    _timer = null;

  }

}