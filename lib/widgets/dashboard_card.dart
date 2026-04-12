import 'package:flutter/material.dart';

import 'package:personal_money_tracker/utils/currency_formatter.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.todayTotal,
    super.key,
  });

  final double todayTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1F6F5F),
            Color(0xFF2D8A76),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's spending",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            CurrencyFormatter.format(todayTotal),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Fast logging keeps your daily total honest and up to date.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
