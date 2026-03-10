import 'package:flutter/material.dart';

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const BottomItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          icon,
          color: isActive ? Colors.purple : Colors.white54,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.purple : Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}