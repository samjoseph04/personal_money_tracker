import 'package:flutter/material.dart';

import 'package:personal_money_tracker/utils/category_style.dart';
import 'package:personal_money_tracker/utils/currency_formatter.dart';
import 'package:personal_money_tracker/utils/expense_insights.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({required this.summary, super.key});

  final ExpenseInsightSummary summary;

  @override
  Widget build(BuildContext context) {
    final topCategory = summary.topCategory;
    final message = topCategory == null
        ? 'Add a few expenses to unlock spending insights.'
        : 'You spent most on ${topCategory.label}.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insights', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          if (topCategory != null) ...[
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(summary.topCategoryTotal),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: topCategory.color),
            ),
          ],
          if (topCategory != null) ...[
            const SizedBox(height: 16),
            ...summary.sortedTotals.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _InsightRow(
                  label: entry.key.label,
                  amount: entry.value,
                  color: entry.key.color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF273330)),
          ),
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF273330),
          ),
        ),
      ],
    );
  }
}
