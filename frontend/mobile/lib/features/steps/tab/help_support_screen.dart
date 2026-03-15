import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget card(String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1f2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            q,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            a,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Help & Support",
        style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  ),),
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "We're here to help you",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          card(
            "How do I earn points?",
            "Walk and track your steps! Every 1000 steps you take earns you 1 point in the WEARN app.",
          ),

          card(
            "How do I redeem rewards?",
            "Go to the Rewards tab and tap 'Redeem Now' on any reward you want to claim.",
          ),

          card(
            "Can I transfer points to friends?",
            "Not yet, but this feature is coming soon in future updates!",
          ),

          const SizedBox(height: 24),

    
        ],
      ),
    );
  }
}