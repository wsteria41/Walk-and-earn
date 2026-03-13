import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/notification_provider.dart';

import 'core/localization/language_controller.dart';

import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/steps/screens/step_dashboard.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WEARN",

      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      /// LANGUAGE
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
