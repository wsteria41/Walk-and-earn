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

  final AuthService authService = AuthService(); //auth service holbogdoh object

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final storage =
      const FlutterSecureStorage(); // secure storage holbogdoh object

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),

            child: Column(
              children: [
                const SizedBox(height: 40),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "WEARN",
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 8
                          ..color = Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    Text(
                      "WEARN",
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFD4B4FF), // light purple
                              Color(0xFF7A1CBE), // dark purple
                            ],
                            stops: [0.0, 0.90, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "WALK. EARN. REPEAT.",
                  style: TextStyle(
                    color: Colors.white54,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      toggleButton("Login", true),
                      toggleButton("Sign Up", false),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                if (!isLogin) input("Full Name", name, LucideIcons.user),

                if (!isLogin) const SizedBox(height: 20),

                input("Email Address", email, LucideIcons.mail),

                const SizedBox(height: 20),

                passwordInput(),

                const SizedBox(height: 20),

                if (isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.purple.shade300),
                    ),
                  ),

                const SizedBox(height: 30),

                mainButton(),

                const SizedBox(height: 20),

                const Text(
                  "Start your fitness journey today and earn rewards with every step you take",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),

                const SizedBox(height: 40),

                /// FEATURE ICONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFeature(LucideIcons.footprints, "Track Steps"),
                    buildFeature(LucideIcons.sparkles, "Earn Points"),
                    buildFeature(LucideIcons.award, "Get Rewards"),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "v1.0.0 • Premium Fitness App",
                  style: TextStyle(color: Colors.white38),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget toggleButton(String title, bool login) {
    bool active = isLogin == login;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = login;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [Color(0xFF7A1CBE), Color(0xFF9C27FF)],
                  )
                : null,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget input(String label, TextEditingController c, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),

        const SizedBox(height: 6),

        TextField(
          controller: c,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.purpleAccent),
            hintText: "Enter your ${label.toLowerCase()}",
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),

        const SizedBox(height: 6),

        TextField(
          controller: password,
          obscureText: !showPassword,
          style: const TextStyle(color: Colors.white),

          decoration: InputDecoration(
            prefixIcon: const Icon(
              LucideIcons.lock,
              color: Colors.purpleAccent,
            ),

            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                color: const Color.fromARGB(255, 128, 11, 148),
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),

            hintText: "Enter your password",
            hintStyle: const TextStyle(color: Colors.white30),

            filled: true,
            fillColor: Colors.white10,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (!isLogin) ...[
          const SizedBox(height: 6),
          const Text(
            "Хамгийн багадаа 6 тэмдэгт байх ёстой",
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ],
    );
  }

  Widget mainButton() {
    return GestureDetector(
      onTap: () {
        if (isLogin) {
          login();
        } else {
          register();
        }
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7A1CBE), Color(0xFF9C27FF)],
          ),
          borderRadius: BorderRadius.circular(40),
        ),

        child: Center(
          child: Text(
            isLogin ? "Login to WEARN" : "Create Account",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildFeature(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF7A1CBE).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF7A1CBE), width: 1.2),
          ),
          child: Icon(icon, color: const Color(0xFFB56DFF), size: 26),
        ),

        const SizedBox(height: 8),

        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
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
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Нэрээ оруулна уу")));
      return;
    }

    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("И-мэйл оруулна уу")));
      return;
    }

    if (password.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Нууц үг оруулна уу")));
      return;
    }

    bool success = await authService.register(
      name.text.trim(),
      email.text.trim(),
      password.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Бүртгэл амжилттай")));
      setState(() => isLogin = true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Бүртгэл амжилтгүй")));
    }
  }
}
