import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import 'package:intl/intl.dart';
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
      final profile = await api.getProfile();

      if (!mounted) return;
      setState(() {
        rewards = r;
        redemptions = h;
        userPoints = int.tryParse(profile["totalPoints"].toString()) ?? 0;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      debugPrint("REWARDS ERROR: $e");
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF7B2FFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A00B4), Color(0xFF7B2FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rewards",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// BALANCE ROW
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "YOUR BALANCE",
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$userPoints",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              "points available",
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B2FFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.emoji_events,
                              color: Colors.white, size: 26),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TABS
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF7B2FFF),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white38,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                      tabs: const [
                        Tab(text: "Available"),
                        Tab(text: "History"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [_buildAvailable(), _buildHistory()],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailable() {
    if (rewards.isEmpty) {
      return const Center(
        child: Text(
          "Урамшуулал байхгүй байна",
          style: TextStyle(color: Colors.white38),
        ),
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
          // ✅ Карт дарахад detail screen нээнэ
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
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Row(
              children: [
                // ЗУРАГ / ICON
                _rewardMedia(imageUrl, type),
                const SizedBox(width: 14),

                // МЭДЭЭЛЭЛ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r["name"] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (r["business_name"] != null)
                        Text(
                          r["business_name"],
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "$required оноо",
                            style: const TextStyle(
                                color: Color(0xFFB985FF), fontSize: 12),
                          ),
                          if (discount != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D9E75)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFF1D9E75)
                                        .withOpacity(0.4)),
                              ),
                              child: Text(
                                "$discount% хөнгөлөлт",
                                style: const TextStyle(
                                  color: Color(0xFF1D9E75),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // REDEEM BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: canRedeem
                        ? const Color(0xFF7B2FFF)
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Redeem",
                    style: TextStyle(
                      color: canRedeem ? Colors.white : Colors.white24,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
        child: Image.network(
          imageUrl,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _rewardIcon(type),
        ),
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
        color: (c["color"] as Color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: (c["color"] as Color).withOpacity(0.3)),
      ),
      child: Icon(c["icon"] as IconData,
          color: c["color"] as Color, size: 26),
    );
  }

  Widget _buildHistory() {
    if (redemptions.isEmpty) {
      return const Center(
        child: Text(
          "Түүх байхгүй байна",
          style: TextStyle(color: Colors.white38),
        ),
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
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A2A2A)),
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
                    Text(
                      r["name"] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${r["points_used"]} points • $date",
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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