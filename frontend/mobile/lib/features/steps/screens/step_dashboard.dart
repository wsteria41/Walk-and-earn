import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile/l10n/app_localizations.dart';

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
  int totalPoints = 0;
  int todayPoints = 0;
  int goal = 10000;

  @override
  void initState() {
    super.initState();

    stepManager = StepManager();

    stepManager.onStepUpdate = (value) {
      if (!mounted) return;

      setState(() {
        steps = value;
      });
    };

    scheduler = StepSyncScheduler(stepManager);

    scheduler.onAfterSync = () async {
      await loadData();
    };

    Future.microtask(() => loadData());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final granted = await stepManager.startTracking();

      if (!mounted) return;
      if (!granted) {
        _showPermissionDialog();
        return;
      }
      scheduler.start();
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          "Health Connect зөвшөөрөл",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Алхалтын мэдээлэл унших зөвшөөрөл шаардлагатай. "
          "Тохиргоо руу орж Health Connect-д зөвшөөрнө үү.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Хойш болгох",
              style: TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8117CE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Тохиргоо нээх"),
          ),
        ],
      ),
    );
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
      if (!mounted) return;
      setState(() {
        name =
            (dashboard["user"]?["name"]?.toString().trim().isNotEmpty ?? false)
            ? dashboard["user"]["name"]
            : "User";

        totalPoints = dashboard["user"]?["totalPoints"] ?? 0;
        goal = dashboard["user"]?["dailyGoal"] ?? 10000;
        todayPoints = dashboard["todayPoints"] ?? 0;
        avatar = dashboard["user"]?["profile_photo"];
        steps = dashboard["todaySteps"] ?? 0;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double get progress => goal <= 0 ? 0 : (steps / goal).clamp(0.0, 1.0);
  String get distance => (steps * 0.0008).toStringAsFixed(1);
  int get calories => (steps * 0.04).toInt();
  String get timeWalked {
    double minutes = steps * 0.01;
    if (minutes < 60) return "${minutes.toStringAsFixed(0)} min";
    return "${(minutes / 60).toStringAsFixed(1)} hrs";
  }

  void changeGoal() {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          l.setDailyGoal,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l.enterSteps,
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8117CE)),
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
            child: Text(
              l.cancel,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8117CE),
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
            child: Text(l.save),
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    final l = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER — history/rewards-тэй ижил gradient ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF59158B), Color(0xFF8117CE)],
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
                            "$totalPoints pts",
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // ── STEP CIRCLE ──────────────────────────────
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
                              Color(0xFF8117CE),
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              steps.toString(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                            Text(
                              l.steps,
                              style: const TextStyle(
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
                                  color: const Color(0xFF8117CE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${(progress * 100).toInt()}% of ${l.goal.toLowerCase()}",
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
                                "${l.goal}: $goal",
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

                // ── STAT TILES ───────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.7,
                  children: [
                    _statTile(l.distance, "$distance km", Icons.route),
                    _statTile(
                      l.calories,
                      "$calories kcal",
                      Icons.local_fire_department,
                    ),
                    _statTile(l.time, timeWalked, Icons.timer),
                    _statTile(
                      l.todayPoints,
                      todayPoints > 0 ? "$todayPoints pts" : "0 pts",
                      Icons.auto_awesome,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── KEEP WALKING BANNER ──────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF59158B), Color(0xFF8117CE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                            Text(
                              l.keepWalking,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "${(goal - steps).clamp(0, goal)} ${l.moreSteps}",
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

  Widget _statTile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
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
              Icon(icon, color: const Color(0xFF8117CE), size: 18),
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
    final l = AppLocalizations.of(context)!;

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
                  label: l.dashboard,
                  isActive: selectedIndex == 0,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 1),
                child: BottomItem(
                  icon: Icons.card_giftcard,
                  label: l.rewards,
                  isActive: selectedIndex == 1,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 2),
                child: BottomItem(
                  icon: Icons.history,
                  label: l.history,
                  isActive: selectedIndex == 2,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 3),
                child: BottomItem(
                  icon: Icons.person_outline,
                  label: l.profile,
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
