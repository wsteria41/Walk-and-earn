import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'reward_detail_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  final ApiService api = ApiService();
  late TabController _tabController;

  List rewards = [];
  List redemptions = [];
  int userPoints = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final r = await api.getRewardList();
      final h = await api.getMyRedemptions();
      final dashboard = await api.getDashboard();

      if (!mounted) return;
      setState(() {
        rewards = r;
        redemptions = h;
        userPoints = dashboard["user"]?["totalPoints"] ?? 0;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
          // ── GRADIENT HEADER BACKGROUND ───────────────────
          Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF59158B), Color(0xFF8117CE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── TITLE ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Text(
                    l.rewards,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── BALANCE CARD ────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B1BB5), Color(0xFF8117CE)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.yourBalance,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "$userPoints",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.pointsAvailable,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── TOGGLE TABS ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6B1BB5), Color(0xFF8117CE)],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white38,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      tabs: [
                        Tab(text: l.available),
                        Tab(text: l.history),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── BODY ────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildAvailable(l), _buildHistory(l)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailable(AppLocalizations l) {
    if (rewards.isEmpty) {
      return Center(
        child: Text("Урамшуулал байхгүй байна",
            style: const TextStyle(color: Colors.white38)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: rewards.length,
      itemBuilder: (context, i) {
        final r = rewards[i];
        final int required =
            int.tryParse(r["required_points"].toString()) ?? 0;
        final int? discount = r["discount_percent"] != null
            ? int.tryParse(r["discount_percent"].toString())
            : null;
        final String type = r["reward_type"] ?? "VOUCHER";
        final String? imageUrl = r["image_url"];
        final bool canRedeem = userPoints >= required;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RewardDetailScreen(
                  reward: r,
                  userPoints: userPoints,
                  onRedeemed: loadData,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _rewardMedia(imageUrl, type),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r["name"] ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      if (r["business_name"] != null)
                        Text(r["business_name"],
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 11)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text("$required оноо",
                              style: const TextStyle(
                                  color: Color(0xFFB985FF), fontSize: 12)),
                          if (discount != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF1D9E75).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFF1D9E75)
                                        .withValues(alpha: 0.4)),
                              ),
                              child: Text("$discount% хөнгөлөлт",
                                  style: const TextStyle(
                                      color: Color(0xFF1D9E75),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: canRedeem
                        ? const Color(0xFF8117CE)
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Авах",
                      style: TextStyle(
                          color: canRedeem ? Colors.white : Colors.white24,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rewardMedia(String? imageUrl, String type) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _rewardIcon(type)),
      );
    }
    return _rewardIcon(type);
  }

  Widget _rewardIcon(String type) {
    final Map<String, Map> config = {
      "DISCOUNT": {"icon": Icons.percent, "color": const Color(0xFF1D9E75)},
      "FREEBIE": {
        "icon": Icons.card_giftcard,
        "color": const Color(0xFFf59e0b)
      },
    };
    final c = config[type] ?? config["DISCOUNT"]!;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: (c["color"] as Color).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: (c["color"] as Color).withValues(alpha: 0.3)),
      ),
      child:
          Icon(c["icon"] as IconData, color: c["color"] as Color, size: 26),
    );
  }

  Widget _buildHistory(AppLocalizations l) {
    if (redemptions.isEmpty) {
      return const Center(
        child: Text("Түүх байхгүй байна",
            style: TextStyle(color: Colors.white38)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: redemptions.length,
      itemBuilder: (context, i) {
        final r = redemptions[i];
        final String status = r["status"] ?? "PENDING";
        final String date = _formatDate(r["redeemed_at"]);

        Color statusColor;
        if (status == "APPROVED") {
          statusColor = Colors.greenAccent;
        } else if (status == "REJECTED") {
          statusColor = Colors.redAccent;
        } else {
          statusColor = const Color(0xFFB985FF);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B0036),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long,
                    color: Color(0xFFB985FF), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r["name"] ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(
                        "${r["points_used"]} ${l.points.toLowerCase()} • $date",
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(status,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String? iso) {
    if (iso == null) return "";
    final d = DateTime.tryParse(iso);
    if (d == null) return "";
    return DateFormat("MMM dd, yyyy").format(d.toLocal());
  }
}