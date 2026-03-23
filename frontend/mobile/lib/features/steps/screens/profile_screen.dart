import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../../../features/steps/tab/edit_profile_screen.dart';
import '../../../features/steps/tab/health_details_screen.dart';
import '../../../features/steps/tab/help_support_screen.dart';
import '../../../features/steps/tab/settings_screen.dart';
import '../../auth/screens/auth_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();

  String profilePhoto = "";
  String name = "";
  String email = "";
  int points = 0;
  int level = 1;
  int totalSteps = 0;
  int rewards = 0;
  int streak = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await apiService.getProfile();
      final stats = await apiService.getTotalStats();
      if (!mounted) return;
      setState(() {
        name = profile["name"] ?? "";
        email = profile["email"] ?? "";
        profilePhoto = profile["profile_photo"] ?? "";
        points = int.tryParse(profile["totalPoints"].toString()) ?? 0;
        level = int.tryParse(profile["level"].toString()) ?? 1;
        totalSteps = int.tryParse(stats["totalSteps"].toString()) ?? 0;
        rewards = int.tryParse(stats["rewards"].toString()) ?? 0;
        streak = int.tryParse(stats["activeDays"].toString()) ?? 0;
        loading = false;
      });
    } catch (e) {
      debugPrint("PROFILE ERROR: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF8A2BE2),
                          Color(0xFF4B0082),
                          Color(0xFF1C1C1E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(l.profile,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 115, 13, 210),
                            Color.fromARGB(255, 90, 9, 148),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.purple,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: profilePhoto.isNotEmpty
                                  ? Image.network(profilePhoto,
                                      fit: BoxFit.cover)
                                  : Center(
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : "U",
                                        style: const TextStyle(
                                            fontSize: 26,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name.isNotEmpty ? name : "User",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(email,
                                    style: const TextStyle(
                                        color: Colors.white70)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildBadge("Level $level"),
                                    const SizedBox(width: 10),
                                    _buildBadge("$points pts"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat(l.totalSteps, _formatSteps(totalSteps),
                        Icons.directions_walk),
                    _buildStat(l.rewards, rewards.toString(),
                        Icons.emoji_events),
                    _buildStat(l.streak, streak.toString(),
                        Icons.local_fire_department),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildMenu(l.editProfile, Icons.person_outline, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()));
              }),
              _buildMenu(l.healthDetails, Icons.favorite_border, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HealthDetailsScreen()));
              }),
              _buildMenu(l.settings, Icons.settings, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()));
              }),
              _buildMenu(l.helpSupport, Icons.help_outline, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen()));
              }),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 214, 80, 70),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(l.logout),
                ),
              ),

              const SizedBox(height: 20),
              const Text("WEARN v1.0.0  Made with ❤️",
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) return "${(steps / 1000).toStringAsFixed(0)}K";
    return steps.toString();
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildStat(String title, String value, IconData icon) {
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
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMenu(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                child: Text(title,
                    style: const TextStyle(color: Colors.white))),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
