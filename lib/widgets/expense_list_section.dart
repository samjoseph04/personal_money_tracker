import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/utils/category_style.dart';
import 'package:personal_money_tracker/utils/currency_formatter.dart';

class ExpenseListSection extends StatelessWidget {
  const ExpenseListSection({required this.expenses, super.key});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const _EmptyExpensesState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return _ExpenseTile(expense: expense);
      },
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: expense.category.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(expense.category.icon, color: expense.category.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(expense.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            CurrencyFormatter.format(expense.amount),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }
}

class _EmptyExpensesState extends StatelessWidget {
  const _EmptyExpensesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 34,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap Add expense to log your first spend in seconds.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
