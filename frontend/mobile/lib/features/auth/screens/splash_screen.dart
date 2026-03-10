import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// 3 секундийн дараа auth screen рүү шилжинэ
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/auth");
    });
  }

  Widget buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF7A1CBE),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,

                  colors: [Colors.white, Color(0xFFD4B4FF), Color(0xFF7A1CBE)],

                  stops: [0.0, 0.90, 1.0],
                ).createShader(bounds);
              },

              child: Text(
                'WEARN',
                style: TextStyle(
                  fontSize: 78,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 5,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SUBTITLE
            const Text(
              "WALK. EARN. REPEAT.",
              style: TextStyle(
                color: Color(0xFF7A1CBE),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 50),

            /// LOADING DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildDot(0), buildDot(1), buildDot(2)],
            ),
          ],
        ),
      ),
    );
  }
}
