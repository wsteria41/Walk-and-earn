import 'package:flutter/material.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/steps/screens/step_dashboard.dart';

void main() {
  runApp(const WearnApp());
}

class WearnApp extends StatelessWidget {
  const WearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WEARN",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF7A1CBE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A1CBE),
          brightness: Brightness.dark,
        ),
      ),

      home: const SplashScreen(),

      routes: {
        "/auth": (context) => const AuthScreen(),
        "/dashboard": (context) => const DashboardScreen(),
      },
    );
  }
}