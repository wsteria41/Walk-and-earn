import 'dart:io';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class StepPermission {
  static Future<bool> request() async {
    if (Platform.isAndroid) {
      final activityStatus = await Permission.activityRecognition.request();
      if (!activityStatus.isGranted) return false;

      final locationStatus = await Permission.locationWhenInUse.request();
      if (!locationStatus.isGranted) return false;

      final health = Health();

      await health.configure();

      final sdkStatus = await health.getHealthConnectSdkStatus();
      if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
        await health.installHealthConnect();
        return false;
      }

      final granted = await health.requestAuthorization(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ],
      );
      if (!granted) return false;

      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      try {
        await health.getTotalStepsInInterval(midnight, now);
        return true;
      } catch (e) {
        return false;
      }
    }

    if (Platform.isIOS) {
      final health = Health();
      await health.configure();

      final hasPermission = await health.hasPermissions(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ],
      );
      if (hasPermission == true) return true;

      final granted = await health.requestAuthorization(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ],
      );
      return granted;
    }
    return false;
  }
}
