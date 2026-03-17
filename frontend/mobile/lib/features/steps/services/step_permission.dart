import 'dart:io';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class StepPermission {
  static Future<bool> request() async {
    try {
      if (Platform.isAndroid) {
        // 1. Activity recognition
        var activityStatus = await Permission.activityRecognition.request();
        log.d("Activity: $activityStatus");

        // 2. Location
        var locationStatus = await Permission.locationWhenInUse.request();
        log.d("Location: $locationStatus");

        if (activityStatus.isPermanentlyDenied ||
            locationStatus.isPermanentlyDenied) {
          await openAppSettings();
          return false;
        }

        if (!activityStatus.isGranted || !locationStatus.isGranted) {
          return false;
        }

        // 3. Health Connect
        final health = Health();
        final sdkStatus = await health.getHealthConnectSdkStatus();

        if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
          log.w("Health Connect SDK not available: $sdkStatus");
          await health.installHealthConnect();
          return false;
        }

        final requested = await health.requestAuthorization(
          [HealthDataType.STEPS],
          permissions: [HealthDataAccess.READ],
        );

        log.i("Health permission result: $requested");

        if (!requested) {
          log.w("❌ Health permission denied");
          return false;
        }

        log.i("Health Connect permission requested ✅");
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);

        try {
          await health.getTotalStepsInInterval(midnight, now);
          log.i("Health permission confirmed ✅");
          return true;
        } catch (e) {
          log.w("Health permission not granted: $e");
          return false; // ✅ зөв
        }
      }

      if (Platform.isIOS) return true;
      return false;
    } catch (e) {
      log.e("Permission error: $e");
      return false;
    }
  }
}
