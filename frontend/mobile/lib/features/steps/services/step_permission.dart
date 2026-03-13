import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class StepPermission {

  static Future<bool> request() async {

    try {

      //Abdroid permission
      if (Platform.isAndroid) {

        PermissionStatus status =
            await Permission.activityRecognition.request();

        if (status.isGranted) {
          return true;
        }

        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }

        return false;

      }

      //IOS health uuruu permission asuuna
      if (Platform.isIOS) {
        return true;
      }

      return false;

    } catch (e) {

      log.i("Permission error: $e");
      return false;

    }

  }

}