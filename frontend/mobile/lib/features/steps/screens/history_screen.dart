import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import 'package:logger/logger.dart';
import 'package:mobile/l10n/app_localizations.dart';

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
      sum += int.tryParse(day["steps"].toString()) ?? 0;
    }
    return sum;
  }

  int get totalPoints {
    int sum = 0;
    for (var day in stats) {
      sum += int.tryParse(day["points"].toString()) ?? 0;
    }
    return sum;
  }

  int get activeDays {
    int count = 0;
    for (var day in stats) {
      if ((int.tryParse(day["steps"].toString()) ?? 0) > 0) count++;
    }
    return count;
  }

  String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "Unknown";
    DateTime? d = DateTime.tryParse(isoDate);
    if (d == null) return "Unknown";
    d = d.toLocal();
    DateTime now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return "Today";
    }
    if (d.year == now.year && d.month == now.month && d.day == now.day - 1) {
      return "Yesterday";
    }
    return "${d.month}/${d.day}";
  }

  Future<void> loadHistory() async {
    try {
      final data = await api.getHistory();
      if (!mounted) return;
      setState(() {
        stats = data.take(7).toList();
        loading = false;
      });
    } catch (e) {
      log.e("History error", error: e);
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
      body: Stack(
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF59158B), Color(0xFF8117CE)],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(l.history,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _weeklySummaryCard(l),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(l.dailyActivity,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ...stats.map((day) {
                  int steps = int.tryParse(day["steps"].toString()) ?? 0;
                  int points = int.tryParse(day["points"].toString()) ?? 0;
                  String date = formatDate(day["date"]);
                  return _activityCard(date, steps, points, l);
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklySummaryCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6B1BB5), Color(0xFF8117CE)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.thisWeek,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryStat(l.totalSteps.toUpperCase(), totalSteps.toString()),
              _summaryStat(l.points.toUpperCase(), "+$totalPoints"),
              _summaryStat(l.days.toUpperCase(), "$activeDays/7"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityCard(
      String date, int steps, int points, AppLocalizations l) {
    double km = steps * 0.0008;
    int cal = (steps * 0.04).toInt();

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
                Text(date,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8117CE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("+$points pts",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _columnStat(l.totalSteps.toUpperCase(), steps.toString()),
                _columnStat(l.calories.toUpperCase(), cal.toString()),
                _columnStat(
                    l.distance.toUpperCase(), "${km.toStringAsFixed(1)} km"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _columnStat(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _summaryStat(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
