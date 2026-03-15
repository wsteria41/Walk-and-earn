import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool showPassword = false;

  final AuthService authService = AuthService();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              /// LOGO
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFD4B4FF), Color(0xFF9B4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "WEARN",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "WALK. EARN. REPEAT.",
                style: TextStyle(
                  color: Color(0xFFB985FF),
                  letterSpacing: 3,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 28),

              /// TOGGLE
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _toggleBtn("Login", true),
                    _toggleBtn("Sign up", false),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// FORM
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  children: [
                    if (!isLogin) ...[
                      _input("Full name", name, LucideIcons.user),
                      const SizedBox(height: 14),
                    ],
                    _input("Email address", email, LucideIcons.mail),
                    const SizedBox(height: 14),
                    _passwordInput(),
                    if (isLogin) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot password?",
                          style: const TextStyle(
                            color: Color(0xFFB985FF),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// MAIN BUTTON
              GestureDetector(
                onTap: () => isLogin ? login() : register(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                   color: const Color(0xFF7B2FFF), 
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      isLogin ? "Login to WEARN" : "Create Account",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Start your fitness journey today and\nearn rewards with every step you take",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              /// FEATURES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _feature(LucideIcons.footprints, "Track Steps"),
                  _feature(LucideIcons.sparkles, "Earn Points"),
                  _feature(LucideIcons.award, "Get Rewards"),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "v1.0.1 • WEARN",
                style: TextStyle(color: Colors.white24, fontSize: 11),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleBtn(String title, bool login) {
    bool active = isLogin == login;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = login),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
          color: active ? const Color(0xFF7B2FFF) : Colors.transparent, // ← gradient биш, цул өнгө
          borderRadius: BorderRadius.circular(40), // ← илүү дугуй
        ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF9B4DFF), size: 18),
            hintText: "Enter your ${label.toLowerCase()}",
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF111111),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7B2FFF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: password,
          obscureText: !showPassword,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: const Icon(LucideIcons.lock, color: Color(0xFF9B4DFF), size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                color: const Color(0xFF7B2FFF),
                size: 18,
              ),
              onPressed: () => setState(() => showPassword = !showPassword),
            ),
            hintText: "Enter your password",
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF111111),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7B2FFF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _feature(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF1B0036),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF4A00B4), width: 1),
          ),
          child: Icon(icon, color: const Color(0xFFB985FF), size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> login() async {
    bool success = await authService.login(email.text, password.text);
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  Future<void> register() async {
    bool success = await authService.register(name.text, email.text, password.text);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created")),
      );
      setState(() => isLogin = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register failed")),
      );
    }
  }
}