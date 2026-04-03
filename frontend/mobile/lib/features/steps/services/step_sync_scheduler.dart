import 'dart:async';
import 'step_manager.dart';
import 'package:logger/logger.dart';

class StepSyncScheduler {
  final StepManager manager;
  final Logger _log = Logger();

  Timer? _timer;
  bool _isRunning = false;

  Future<void> Function()? onAfterSync;

  StepSyncScheduler(this.manager);

  Future<void> start() async {
    if (_isRunning) {
      _log.i("StepSyncScheduler already running");
      return;
    }

    _log.i("StepSyncScheduler started");
    _isRunning = true;

    Future.delayed(const Duration(seconds: 15), () async {
      try {
        await manager.syncSteps();

        if (onAfterSync != null) {
          await onAfterSync!();
        }

      } catch (e) {
        _log.e("INITIAL SYNC ERROR: $e");
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      try {
        await manager.syncSteps();

        if (onAfterSync != null) {
          await onAfterSync!();
        }

      } catch (e) {
        _log.e("SYNC SCHEDULER ERROR: $e");
      }
    });
  }

  void stop() {
    _log.i("StepSyncScheduler stopped");

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }
}