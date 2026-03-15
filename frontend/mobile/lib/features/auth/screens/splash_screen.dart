import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  final storage = const FlutterSecureStorage();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

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
    String? token = await storage.read(key: "token");
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (token != null) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      Navigator.pushReplacementNamed(context, "/auth");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0015),
      body: Container(
          width: double.infinity,  
          height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0015),
              Color(0xFF1B0036),
              Color(0xFF2D0060),
              Color(0xFF1A0040),
              Color(0xFF0D001A),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [

            Positioned(
              top: -80,
              left: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7B2FFF).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -60,
              right: -40,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4A00B4).withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
             width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const Spacer(flex: 3),


                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFD4B4FF),
                          Color(0xFF9B4DFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      "WEARN",
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

    
                  const Text(
                    "WALK. EARN. REPEAT.",
                    style: TextStyle(
                      color: Color(0xFFB985FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                    ),
                  ),

                  const Spacer(flex: 4),

                  const Text(
                    "v1.0.0",
                    style: TextStyle(
                      color: Color(0xFF6B4A8A),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}