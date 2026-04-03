
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/notification_provider.dart';

import 'core/localization/language_controller.dart';

import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/steps/screens/step_dashboard.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Background handler burtgeh
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Notification servise ehluuleh
  await NotificationService.init();
  await NotificationService.scheduleDailyReminder();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => LanguageController()),
      ],
      child: const WearnApp(),
    ),
  );
}

class WearnApp extends StatelessWidget {
  const WearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WEARN",
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0A0015)),
      locale: context.watch<LanguageController>().locale,

      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      home: const SplashScreen(),

      routes: {
        "/auth": (context) => const AuthScreen(),
        "/dashboard": (context) => const DashboardScreen(),
      },
    );
  }
}
