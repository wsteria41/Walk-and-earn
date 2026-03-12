import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget card(String q,String a){

    return Container(
      margin: const EdgeInsets.only(bottom:16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1f2937),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(q,style:const TextStyle(fontWeight:FontWeight.bold)),
          const SizedBox(height:8),
          Text(a)

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.black
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            card(
              "How do i earn points?",
              "Walk and track your steps. Every 1000 steps earns you 1 point."
            ),

            card(
              "How do i redeem rewards?",
              "Go to the Rewards tab and tap Redeem."
            ),

            card(
              "Can i transfer points?",
              "Not yet, but this feature is coming soon."
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity,50)
              ),
              child: const Text("View Documentation")
            )

          ],
        ),
      ),
    );
  }
}