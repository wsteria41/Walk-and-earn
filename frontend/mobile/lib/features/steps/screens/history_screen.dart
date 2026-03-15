
import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import 'package:logger/logger.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final ApiService api = ApiService();
  final Logger log = Logger();

  List stats = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  int get totalSteps {
    int sum = 0;
    for (var day in stats) {
      int steps = int.tryParse(day["steps"].toString()) ?? 0;
      sum += steps;
    }
    return sum;
  }

  int get totalPoints {
    int sum = 0;
    for (var day in stats) {
      int pts = int.tryParse(day["points"].toString()) ?? 0;
      sum += pts;
    }
    return sum;
  }

  int get activeDays {
    int count = 0;
    for (var day in stats) {
      int steps = int.tryParse(day["steps"].toString()) ?? 0;
      if (steps > 0) count++;
    }
    return count;
  }

  String formatDate(String? isoDate) {

    if (isoDate == null || isoDate.isEmpty) {
      return "Unknown";
    }

    DateTime? d = DateTime.tryParse(isoDate);
    if (d == null) return "Unknown";

    d = d.toLocal();
    DateTime now = DateTime.now();

    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return "Today";
    }

    if (d.year == now.year &&
        d.month == now.month &&
        d.day == now.day - 1) {
      return "Yesterday";
    }

    return "${d.month}/${d.day}";
  }

  Future<void> loadHistory() async {

    try {

      final data = await api.getHistory();

      log.i("HISTORY LENGTH: ${data.length}");

      if (!mounted) return;

      setState(() {
        stats = data.take(7).toList();
        loading = false;
      });

    } catch (e) {

      log.e("History error", error: e);

      setState(() {
        loading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// GRADIENT HEADER
          Container(
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF59158B),
                  Color(0xFF8117CE),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [

                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "History",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: weeklySummaryCard(),
                ),

                const SizedBox(height: 15),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Daily Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                ...stats.map((day) {

                  int steps = int.tryParse(day["steps"].toString()) ?? 0;
                  int points = int.tryParse(day["points"].toString()) ?? 0;
                  String date = formatDate(day["date"]);

                  return activityCard(date, steps, points);

                }),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget weeklySummaryCard() {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6B1BB5),
            Color(0xFF8117CE),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "This week",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              summaryStat("STEPS", totalSteps.toString()),
              summaryStat("POINTS", "+$totalPoints"),
              summaryStat("DAYS", "$activeDays/7"),
            ],
          ),
        ],
      ),
    );
  }

  Widget activityCard(String date, int steps, int points) {

    double km = steps * 0.0008;
    int calories = (steps * 0.04).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8117CE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "+$points pts",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                columnStat("STEPS", steps.toString()),
                columnStat("CALORIES", calories.toString()),
                columnStat("DISTANCE", "${km.toStringAsFixed(1)} km"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget columnStat(String title, String value) {

    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget summaryStat(String title, String value) {

    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
