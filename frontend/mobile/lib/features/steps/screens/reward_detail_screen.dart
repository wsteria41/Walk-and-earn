import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class RewardDetailScreen extends StatefulWidget {
  final Map reward;
  final int userPoints;
  final VoidCallback onRedeemed;

  const RewardDetailScreen({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onRedeemed,
  });

  @override
  State<RewardDetailScreen> createState() => _RewardDetailScreenState();
}

class _RewardDetailScreenState extends State<RewardDetailScreen> {
  final ApiService api = ApiService();
  bool loading = false;

  int get required =>
      int.tryParse(widget.reward["required_points"].toString()) ?? 0;
  int? get discount => widget.reward["discount_percent"] != null
      ? int.tryParse(widget.reward["discount_percent"].toString())
      : null;
  bool get canRedeem => widget.userPoints >= required;

  Future<void> _redeem() async {
    setState(() => loading = true);
    try {
      await api.redeemReward(widget.reward["id"]);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Амжилттай! Хүлээгдэж байна"),
          backgroundColor: const Color(0xFF7B2FFF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      widget.onRedeemed();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll("Exception: ", "")),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = widget.reward["image_url"];
    final String name = widget.reward["name"] ?? "";
    final String? business = widget.reward["business_name"];
    final String? description = widget.reward["description"];
    final String type = widget.reward["reward_type"] ?? "VOUCHER";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // ── HERO IMAGE ──────────────────────────────
          Stack(
            children: [
              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  image: (imageUrl != null && imageUrl.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? Center(
                        child: Icon(
                          type == "DISCOUNT"
                              ? Icons.percent
                              : Icons.card_giftcard,
                          size: 80,
                          color: const Color(0xFF7B2FFF).withOpacity(0.5),
                        ),
                      )
                    : null,
              ),
              // Gradient overlay
              Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Back button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── CONTENT ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Нэр + байгууллага
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (business != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      business,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Шаардлагатай оноо + хөнгөлөлт
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B2FFF).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF7B2FFF).withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome,
                                color: Color(0xFFB985FF), size: 14),
                            const SizedBox(width: 5),
                            Text(
                              "$required оноо",
                              style: const TextStyle(
                                color: Color(0xFFB985FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (discount != null) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D9E75).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color(0xFF1D9E75).withOpacity(0.4)),
                          ),
                          child: Text(
                            "$discount% хөнгөлөлт",
                            style: const TextStyle(
                              color: Color(0xFF1D9E75),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // What's included
                  const Text(
                    "What's included",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description ??
                        "Энэхүү урамшуулал нь хамтрагч байгууллагад хүчинтэй бөгөөд бусад урамшууллуудтай хавсарч ашиглах боломжгүй.",
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Таны оноо
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
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
                                color: Colors.white38,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.userPoints}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              canRedeem
                                  ? "Хүрэлцэхүйц оноо байна"
                                  : "${required - widget.userPoints} оноо дутуу",
                              style: TextStyle(
                                color: canRedeem
                                    ? const Color(0xFF1D9E75)
                                    : Colors.redAccent,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.emoji_events,
                          color: canRedeem
                              ? const Color(0xFF7B2FFF)
                              : Colors.white24,
                          size: 36,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── REDEEM BUTTON ────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (canRedeem && !loading) ? _redeem : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canRedeem
                        ? const Color(0xFF7B2FFF)
                        : const Color(0xFF2A2A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          canRedeem ? "Redeem now" : "Оноо хүрэлцэхгүй",
                          style: TextStyle(
                            color:
                                canRedeem ? Colors.white : Colors.white38,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}