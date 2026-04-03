
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static final _localNotif = FlutterLocalNotificationsPlugin();
static Future<void> init() async {
  await _fcm.requestPermission(alert: true, badge: true, sound: true);

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();

  await _localNotif.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
  );

  final token = await _fcm.getToken();
  debugPrint("FCM Token: $token");

  FirebaseMessaging.onMessage.listen((message) {
    _showLocalNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint("Notification clicked!");
  });

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    debugPrint("Opened from terminated state");
  }
}

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotif.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'wearn_channel',
          'WEARN Notifications',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFFB56DFF),
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> scheduleDailyReminder() async {
    await _localNotif.periodicallyShow(
      id: 0,
      title: ' Алхалтын сануулга',
      body: 'Өнөөдөр хангалттай алхсан уу? Зорилгодоо хүрээрэй!',
      repeatInterval: RepeatInterval.daily,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'wearn_daily',
          'Өдөр тутмын сануулга',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  static Future<void> showGoalAchieved(int steps) async {
    await _localNotif.show(
      id: 1,
      title: ' Баяр хүргэе!',
      body: '$steps алхам хийлээ! Өнөөдрийн зорилго биелсэн!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'wearn_achievement',
          'Амжилтын мэдэгдэл',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
