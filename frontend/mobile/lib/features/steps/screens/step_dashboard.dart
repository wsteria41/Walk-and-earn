import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../services/step_counter.dart';
import '../../../components/stat_card.dart';
import '../../../components/bottom_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  final StepCounter stepCounter = StepCounter();

  String name = "User";
  int steps = 0;
  int points = 0;

  final int goal = 10000;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      /// backend profile
      var profile = await apiService.getProfile();

      /// phone step counter
      int deviceSteps = await stepCounter.getTodaySteps();

      setState(() {
        name = profile["name"] ?? "User";
        points = profile["points"] ?? 0;
        steps = deviceSteps;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double get progress {
    return (steps / goal).clamp(0, 1);
  }

  int get remaining {
    return goal - steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5A0FA3),
                    Color(0xFF7A1CBE),
                    Color(0xFF9B2FFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// HI NAME
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hi ❤️",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      /// POINTS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),

                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 16,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              "$points",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// AVATAR
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.purpleAccent,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// STEP CIRCLE
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,

                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: Colors.white10,

                    valueColor: const AlwaysStoppedAnimation(Color(0xFF9B4DFF)),
                  ),
                ),

                Column(
                  children: [
                    Text(
                      steps.toString(),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const Text(
                      "steps",
                      style: TextStyle(color: Colors.white54),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "${(progress * 100).toInt()}% of goal",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Goal: $goal",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 35),

            /// STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatCard(
                    title: "Distance",
                    value: "${(steps * 0.0008).toStringAsFixed(2)} km",
                    icon: Icons.route,
                  ),

                  StatCard(
                    title: "Calories",
                    value: "${(steps * 0.04).toInt()} kcal",
                    icon: Icons.local_fire_department,
                  ),
                  StatCard(
                    title: "Time",
                    value: "${(steps / 1000).toStringAsFixed(1)} hrs",
                    icon: Icons.timer,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// MOTIVATION CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  gradient: const LinearGradient(
                    colors: [Color(0xFF7A1CBE), Color(0xFFB044FF)],
                  ),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),

                    const SizedBox(width: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Keep Walking!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "$remaining more steps to reach your goal!",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// BOTTOM NAV
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),

              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white10)),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomItem(icon: Icons.home, label: "Home", isActive: true),

                  BottomItem(icon: Icons.card_giftcard, label: "Rewards"),

                  BottomItem(icon: Icons.history, label: "History"),

                  BottomItem(icon: Icons.person_outline, label: "Profile"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
