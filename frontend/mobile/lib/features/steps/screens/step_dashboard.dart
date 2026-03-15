import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import 'package:health/health.dart';

import '../../../components/bottom_item.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rewards_screen.dart';

import '../services/step_manager.dart';
import '../services/step_sync_scheduler.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();

  late StepManager stepManager;
  late StepSyncScheduler scheduler;

  int selectedIndex = 0;
  String name = "User";
  String? avatar;
  int steps = 0;
  int points = 0;
  int todayPoints = 0;
  int goal = 10000;

@override
void initState() {
  super.initState();
  
  debugPrint("=== DASHBOARD initState START ===");
  
  stepManager = StepManager();
  stepManager.onStepUpdate = (value) {
    if (!mounted) return;
    setState(() => steps = value);
  };

  debugPrint("=== CALLING _loadTodayStepsFromHealth ===");
  _loadTodayStepsFromHealth();
  
  debugPrint("=== CALLING startTracking ===");
  stepManager.startTracking();
  
  scheduler = StepSyncScheduler(stepManager);
  scheduler.start();
  
  debugPrint("=== CALLING loadData ===");
  loadData();
  
  debugPrint("=== DASHBOARD initState END ===");
}

  Future<void> _loadTodayStepsFromHealth() async {
    debugPrint("_loadTodayStepsFromHealth CALLED");
    try {
      final health = Health();
      final authorized = await health.requestAuthorization([
        HealthDataType.STEPS,
      ]);
      debugPrint("Authorization result: $authorized");
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      final todaySteps = await health.getTotalStepsInInterval(midnight, now);
      debugPrint("HEALTH TODAY STEPS: $todaySteps");
      if (!mounted) return;
      setState(() => steps = todaySteps ?? 0);
      if ((todaySteps ?? 0) > 0) stepManager.syncTodayFromHealth();
    } catch (e, stack) {
      debugPrint("HEALTH LOAD ERROR: $e");
      debugPrint("STACK: $stack");
    }
  }

  @override
  void dispose() {
    scheduler.stop();
    stepManager.stopTracking();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      var dashboard = await apiService.getDashboard();
      setState(() {
        name = dashboard["user"]?["name"] ?? "User";
        points = dashboard["user"]?["totalPoints"] ?? 0;
        goal = dashboard["user"]?["dailyGoal"] ?? 10000;
        todayPoints = dashboard["todayPoints"] ?? 0;
        avatar = dashboard["user"]?["profile_photo"];
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double get progress => goal <= 0 ? 0 : (steps / goal).clamp(0.0, 1.0);
  String get distance => (steps * 0.0008).toStringAsFixed(1);
  int get calories => (steps * 0.04).toInt();
  String get timeWalked => "${(steps * 0.01 / 60).toStringAsFixed(1)} hrs";

  void changeGoal() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          "Set Daily Goal",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter steps (ex: 10000)",
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7B2FFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF9B4DFF), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B2FFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              int newGoal = int.tryParse(controller.text) ?? goal;
              await apiService.updateGoal(newGoal);
              setState(() => goal = newGoal);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A00B4), Color(0xFF7B2FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hi",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
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
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "$points",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    /// AVATAR
                    GestureDetector(
                      onTap: () => setState(() => selectedIndex = 3),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white24,
                        backgroundImage: (avatar != null && avatar!.isNotEmpty)
                            ? NetworkImage(avatar!)
                            : null,
                        child: (avatar == null || avatar!.isEmpty)
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : "U",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// BODY
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 32),

                /// STEP CIRCLE
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: const Color(0xFF2A2A3A),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF7B2FFF),
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatSteps(steps),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                            const Text(
                              "steps",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: changeGoal,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B2FFF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${(progress * 100).toInt()}% of goal",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: changeGoal,
                              child: Text(
                                "Goal: $goal",
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// STATS GRID
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.7,
                  children: [
                    _statTile("Distance", "$distance km", Icons.route),
                    _statTile(
                      "Calories",
                      "$calories kcal",
                      Icons.local_fire_department,
                    ),
                    _statTile("Time", timeWalked, Icons.timer),
                    _statTile("Time", timeWalked, Icons.timer),
                  ],
                ),

                const SizedBox(height: 16),

                /// KEEP WALKING BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2FFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_walk,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Keep Walking!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "${(goal - steps).clamp(0, goal)} more steps to reach your goal!",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSteps(int s) {
    if (s >= 1000) return "${(s / 1000).toStringAsFixed(1)}k";
    return s.toString();
  }

  Widget _statTile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          Row(
            children: [
              Icon(icon, color: const Color(0xFF9B4DFF), size: 18),
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      buildHome(),
      const RewardsScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: screens[selectedIndex]),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0D),
            border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 0),
                child: BottomItem(
                  icon: Icons.home,
                  label: "Home",
                  isActive: selectedIndex == 0,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 1),
                child: BottomItem(
                  icon: Icons.card_giftcard,
                  label: "Rewards",
                  isActive: selectedIndex == 1,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 2),
                child: BottomItem(
                  icon: Icons.history,
                  label: "History",
                  isActive: selectedIndex == 2,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 3),
                child: BottomItem(
                  icon: Icons.person_outline,
                  label: "Profile",
                  isActive: selectedIndex == 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
