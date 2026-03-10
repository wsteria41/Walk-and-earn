import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                    children: const [
                      Text(
                        "Hi",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Name",
                        style: TextStyle(
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
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.auto_awesome,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              "125",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// AVATAR
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.purpleAccent,
                        child: const Text(
                          "B",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
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
                    value: 0.75,
                    strokeWidth: 14,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation(
                      Color(0xFF9B4DFF),
                    ),
                  ),
                ),

                Column(
                  children: const [

                    Text(
                      "7,500",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      "steps",
                      style: TextStyle(color: Colors.white54),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "75% of goal",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Goal: 10,000",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 35),

            /// STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  StatCard(
                    title: "Distance",
                    value: "6.2 km",
                  ),

                  StatCard(
                    title: "Calories",
                    value: "625 kcal",
                  ),

                  StatCard(
                    title: "Time",
                    value: "1.5 hrs",
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
                    colors: [
                      Color(0xFF7A1CBE),
                      Color(0xFFB044FF),
                    ],
                  ),
                ),
                child: Row(
                  children: const [

                    Icon(Icons.auto_awesome,
                        color: Colors.white, size: 28),

                    SizedBox(width: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Keep Walking!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "2500 more steps to reach your goal!",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// BOTTOM NAV
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [

                  BottomItem(Icons.home, "Home", true),
                  BottomItem(Icons.card_giftcard, "Rewards", false),
                  BottomItem(Icons.history, "History", false),
                  BottomItem(Icons.person_outline, "Profile", false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2430),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomItem(this.icon, this.label, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Icon(
          icon,
          color: active ? Colors.purpleAccent : Colors.white54,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            color: active ? Colors.purpleAccent : Colors.white54,
            fontSize: 11,
          ),
        )
      ],
    );
  }
}