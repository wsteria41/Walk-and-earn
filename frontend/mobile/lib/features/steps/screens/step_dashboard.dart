import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

import '../../../components/stat_card.dart';
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

    /// STEP MANAGER
    stepManager = StepManager();
    stepManager.startTracking();

    /// AUTO SYNC
    scheduler = StepSyncScheduler(stepManager);
    scheduler.start();

    /// LOAD DASHBOARD DATA
    loadData();
  }

  @override
  void dispose() {

    scheduler.stop();
    stepManager.stopTracking();

    super.dispose();
  }

  /// BACKEND DASHBOARD DATA
  Future<void> loadData() async {

    try {

      var dashboard = await apiService.getDashboard();

      setState(() {

        name =
            dashboard["user"]?["name"] ??
            dashboard["user"]?["full_name"] ??
            "User";

        points = dashboard["user"]?["totalPoints"] ?? 0;

        goal = dashboard["user"]?["dailyGoal"] ?? 10000;

        todayPoints = dashboard["todayPoints"] ?? 0;

        steps = dashboard["todaySteps"] ?? 0;

        avatar = dashboard["user"]?["profile_photo"];

      });

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// PROGRESS
  double get progress {
    if (goal == 0) return 0;
    return (steps / goal).clamp(0, 1);
  }

  String get distance => (steps * 0.0008).toStringAsFixed(2);

  int get calories => (steps * 0.04).toInt();

  String get timeWalked => (steps * 0.01).toStringAsFixed(0);

  /// CHANGE GOAL
  void changeGoal() {

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(

          title: const Text("Set Daily Goal"),

          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter steps (ex: 10000)",
            ),
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                int newGoal = int.tryParse(controller.text) ?? goal;

                await apiService.updateGoal(newGoal);

                 if (!mounted) return;
                setState(() {
                  goal = newGoal;
                });

                Navigator.pop(context);

              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// HOME UI
  Widget buildHome() {

    return SingleChildScrollView(

      child: Column(

        children: [

          /// HEADER
          Container(

            height: 150,
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Hi",
                      style: TextStyle(color: Colors.white70),
                    ),

                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [

                    /// TOTAL POINTS
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
                    GestureDetector(

                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },

                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        backgroundImage: (avatar != null && avatar!.isNotEmpty)
                            ? NetworkImage(avatar!)
                            : null,

                        child: (avatar == null || avatar!.isEmpty)
                            ? Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : "U",
                                style: const TextStyle(color: Colors.white),
                              )
                            : null,
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
                  valueColor:
                      const AlwaysStoppedAnimation(Color(0xFF9B4DFF)),
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

                  Text(
                    "${(progress * 100).toInt()}% of goal",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  GestureDetector(
                    onTap: changeGoal,

                    child: Text(
                      "Goal: $goal",
                      style: const TextStyle(color: Colors.white38),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// STATS
          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.5,

              children: [

                StatCard(
                  title: "Distance",
                  value: "$distance km",
                  icon: Icons.route,
                ),

                StatCard(
                  title: "Calories",
                  value: "$calories kcal",
                  icon: Icons.local_fire_department,
                ),

                StatCard(
                  title: "Time",
                  value: "$timeWalked min",
                  icon: Icons.timer,
                ),

                StatCard(
                  title: "Total points",
                  value: "$points",
                  icon: Icons.star,
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
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

          padding: const EdgeInsets.symmetric(vertical: 12),

          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white10)),
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