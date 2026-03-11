import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ApiService apiService = ApiService();

  String name = "";
  String email = "";
  int points = 0;
  int level = 1;

  int totalSteps = 0;
  int rewards = 0;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {

      final data = await apiService.getProfile();

      debugPrint("PROFILE DATA: $data");

      if (!mounted) return;

      setState(() {

        /// USER INFO
        name =
            data["user"]?["name"] ??
            data["name"] ??
            "";

        email =
            data["user"]?["email"] ??
            data["email"] ??
            "";

        points =
            data["user"]?["totalPoints"] ??
            data["totalPoints"] ??
            0;

        level =
            data["user"]?["level"] ??
            data["level"] ??
            1;

        /// STATS (dashboard-тай адил parse)
        totalSteps =
            data["stats"]?["totalSteps"] ??
            data["totalSteps"] ??
            data["steps"] ??
            0;

        rewards =
            data["stats"]?["rewards"] ??
            data["rewards"] ??
            data["rewardCount"] ??
            0;

        streak =
            data["stats"]?["streak"] ??
            data["streak"] ??
            data["currentStreak"] ??
            0;

      });

    } catch (e) {
      debugPrint("PROFILE ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// TOP HEADER
              Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.all(20),

                    /// ШИНЭ GRADIENT
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF8A2BE2), // purple
                          Color(0xFF4B0082), // dark purple
                          Color(0xFF1C1C1E)  // almost black
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      /// ДУГУЙ БИШ
                      borderRadius: BorderRadius.zero,
                    ),

                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  /// PROFILE CARD
                  Positioned(
                    bottom: -40,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff1c1c1e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [

                          /// AVATAR
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9B2FFF),
                                  Color(0xFF6A0DAD)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : "U",
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  name.isNotEmpty ? name : "User",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  email,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    buildBadge("Level $level"),
                                    const SizedBox(width: 10),
                                    buildBadge("$points pts"),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 60),

              /// STATS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    buildStat("Steps", formatSteps(totalSteps), Icons.directions_walk),

                    buildStat("Rewards", rewards.toString(), Icons.emoji_events),

                    buildStat("Streak", streak.toString(), Icons.local_fire_department),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              buildMenu("Edit Profile", Icons.person_outline),
              buildMenu("Health Details", Icons.favorite_border),
              buildMenu("Settings", Icons.settings),
              buildMenu("Help & Support", Icons.help_outline),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Logout"),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "WEARN v1.0.0  Made with ❤️",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String formatSteps(int steps) {
    if (steps >= 1000) {
      return "${(steps / 1000).toStringAsFixed(0)}K";
    }
    return steps.toString();
  }

  Widget buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget buildStat(String title, String value, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1c1c1e),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.purpleAccent),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenu(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1c1c1e),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white54,
            size: 16,
          )
        ],
      ),
    );
  }
}