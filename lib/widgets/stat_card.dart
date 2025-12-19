import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  const StatCard({
    super.key,
    required this.label,
    required this.amount,
    required this.backgroundColor,
    this.textColor = Colors.black87,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              // ignore: deprecated_member_use
              color: textColor.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
