import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../core/storage/secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  final storage = SecureStorage();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    checkLogin();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    String? token = await storage.getToken();
    print("SPLASH TOKEN: $token");

    if (!mounted) return;

    
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, "/auth");
      return;
    }

    try {
      final res = await http.get(
        Uri.parse("https://wearn.me/users/profile"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("TOKEN CHECK STATUS: ${res.statusCode}");

      if (res.statusCode == 200) {
       
        Navigator.pushReplacementNamed(context, "/dashboard");
      } else {
        
        await storage.deleteToken();
        Navigator.pushReplacementNamed(context, "/auth");
      }
    } catch (e) {
     
      await storage.deleteToken();
      Navigator.pushReplacementNamed(context, "/auth");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "WEARN",
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "WALK. EARN. REPEAT.",
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}