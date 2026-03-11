import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../services/step_counter.dart';
import '../../../components/stat_card.dart';
import '../../../components/bottom_item.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rewards_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final ApiService apiService = ApiService();
  final StepCounter stepCounter = StepCounter();

  int selectedIndex = 0;

  String name = "User";
  int steps = 0;
  int points = 0;
  int todayPoints = 0;
  int goal = 10000;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      var dashboard = await apiService.getDashboard();

      int deviceSteps = await stepCounter.getTodaySteps();

      setState(() {
        name = dashboard["user"]["name"] ?? "User";
        points = dashboard["user"]["totalPoints"] ?? 0;
        goal = dashboard["user"]["dailyGoal"] ?? 10000;
        todayPoints = dashboard["todayPoints"] ?? 0;
        steps = deviceSteps;
      });

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double get progress => (steps / goal).clamp(0, 1);

  int get remaining {
    int r = goal - steps;
    return r < 0 ? 0 : r;
  }

  String get distance => (steps * 0.0008).toStringAsFixed(2);

  int get calories => (steps * 0.04).toInt();

  String get timeWalked => (steps / 1000).toStringAsFixed(1);

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

  Widget buildHome() {
    return SingleChildScrollView(
      child: Column(
        children: [

          Container(
            height: 200,
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

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),

                      child: Row(
                        children: [

                          const Icon(Icons.auto_awesome,color: Colors.white,size: 16),

                          const SizedBox(width: 6),

                          Text("$points",style: const TextStyle(color: Colors.white)),

                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Text(name[0].toUpperCase()),
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

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
                        color: Colors.white),
                  ),

                  const Text("steps",style: TextStyle(color: Colors.white54)),

                  Text("${(progress * 100).toInt()}% of goal",
                      style: const TextStyle(color: Colors.white70)),

                  GestureDetector(
                    onTap: changeGoal,
                    child: Text("Goal: $goal",
                        style: const TextStyle(color: Colors.white38)),
                  )
                ],
              )
            ],
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 2.4,

              children: [

                StatCard(title: "Distance",value: "$distance km",icon: Icons.route),

                StatCard(title: "Calories",value: "$calories kcal",icon: Icons.local_fire_department),

                StatCard(title: "Time",value: "$timeWalked hrs",icon: Icons.timer),

                StatCard(title: "Points Today",value: "$todayPoints",icon: Icons.star),

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

      body: SafeArea(
        child: screens[selectedIndex],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),

        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10)),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            GestureDetector(
              onTap: () => setState(()=>selectedIndex=0),
              child: BottomItem(icon: Icons.home,label: "Home",isActive: selectedIndex==0),
            ),

            GestureDetector(
              onTap: () => setState(()=>selectedIndex=1),
              child: BottomItem(icon: Icons.card_giftcard,label: "Rewards",isActive: selectedIndex==1),
            ),

            GestureDetector(
              onTap: () => setState(()=>selectedIndex=2),
              child: BottomItem(icon: Icons.history,label: "History",isActive: selectedIndex==2),
            ),

            GestureDetector(
              onTap: () => setState(()=>selectedIndex=3),
              child: BottomItem(icon: Icons.person_outline,label: "Profile",isActive: selectedIndex==3),
            ),

          ],
        ),
      ),
    );
  }
}