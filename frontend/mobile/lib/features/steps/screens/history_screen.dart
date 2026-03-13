import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService api = ApiService();

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
      int steps = int.tryParse(day["steps"].toString()) ?? 0;
      sum += (steps / 1000).floor();
    }
    return sum;
  }

  int get activeDays {
    int count = 0;
    for (var day in stats) {
      int steps = int.tryParse(day["total_steps"].toString()) ?? 0;
      if (steps > 0) {
        count++;
      }
    }
    return count;
  }

String formatDate(String? isoDate) {

  if (isoDate == null || isoDate.isEmpty) {
    return "Unknown";
  }

  DateTime? d = DateTime.tryParse(isoDate);

  if (d == null) {
    return "Unknown";
  }

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

    print("HISTORY LENGTH: ${data.length}");
    print("HISTORY DATA: $data");

      if (!mounted) return;

      setState(() {
        stats = data.take(7).toList();
        loading = false;
      });
    } catch (e) {
      print("History error: $e");

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
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "History",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: weeklySummaryCard(),
            ),

            const SizedBox(height: 20),

            ...stats.map((day) {
              int steps = int.tryParse(day["steps"].toString()) ?? 0;
              int points = int.tryParse(day["points"].toString()) ?? 0;

              String date = formatDate(day["date"]);

              return activityCard(date, steps, points);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget activityCard(String date, int steps, int points) {
    double km = steps * 0.0008;
    int calories = (steps * 0.04).toInt();

    double progress = steps / 10000;
    if (progress > 1) progress = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E293B),
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple,
                  ),

                  child: Text(
                    "+$points pts",
                    style: const TextStyle(color: Colors.white),
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

                columnStat("DISTANCE", "${km.toStringAsFixed(2)} km"),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: progress,
              color: Colors.purpleAccent,
              backgroundColor: Colors.white10,
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
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget weeklySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Week",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              summaryStat("STEPS", totalSteps.toString()),

              summaryStat("POINTS", "+${totalPoints}"),

              summaryStat("DAYS", "$activeDays/7"),
            ],
          ),
        ],
      ),
    );
  }

  Widget summaryStat(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
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
