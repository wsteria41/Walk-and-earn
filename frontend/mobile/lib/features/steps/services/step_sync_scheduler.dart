import 'dart:async';
import 'step_manager.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class StepSyncScheduler {
  final StepManager manager;

  Timer? _timer;
  bool _isRunning = false;

  StepSyncScheduler(this.manager);
  void start() {
    if (_isRunning) {
      log.i("StepSyncScheduler already running");
      return;
    }

    log.i("StepSyncScheduler started");
    _isRunning = true;

    // ← Апп нээхэд шууд нэг удаа sync хийнэ
    Future.delayed(const Duration(seconds: 3), () async {
      try {
        await manager.syncSteps();
      } catch (e) {
        log.e("INITIAL SYNC ERROR: $e");
      }
    });

    // Цааш 60 секунд тутамд үргэлжлүүлнэ
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      try {
        await manager.syncSteps();
      } catch (e) {
        log.e("SYNC SCHEDULER ERROR: $e");
      }
    });
  }

  void stop() {
    log.i("StepSyncScheduler stopped");

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }
}
