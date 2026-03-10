import 'package:permission_handler/permission_handler.dart';

class StepPermission {

  static Future<bool> request() async {

    var status = await Permission.activityRecognition.request();

    return status.isGranted;

  }

}