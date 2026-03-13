import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class StepPermission {

  static Future<bool> request() async {

    try {

      /// ANDROID → Activity Recognition permission
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

      /// IOS → Health plugin өөрөө permission асууна
      if (Platform.isIOS) {
        return true;
      }

      return false;

    } catch (e) {

      print("Permission error: $e");
      return false;

    }

  }

}