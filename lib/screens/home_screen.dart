import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:personal_money_tracker/providers/expense_provider.dart';
import 'package:personal_money_tracker/widgets/add_expense_sheet.dart';
import 'package:personal_money_tracker/widgets/dashboard_card.dart';
import 'package:personal_money_tracker/widgets/expense_list_section.dart';
import 'package:personal_money_tracker/widgets/insight_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((ExpenseProvider value) => value.isLoading);
    final todayTotal =
        context.select((ExpenseProvider value) => value.todayTotal);
    final recentExpenses =
        context.select((ExpenseProvider value) => value.recentExpenses);
    final insights =
        context.select((ExpenseProvider value) => value.insights);
    final errorMessage =
        context.select((ExpenseProvider value) => value.errorMessage);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddExpenseSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add expense'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Money Tracker',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('EEEE, d MMMM').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              DashboardCard(todayTotal: todayTotal),
              const SizedBox(height: 16),
              InsightCard(summary: insights),
              const SizedBox(height: 20),
              Text(
                'Recent expenses',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (errorMessage != null) ...[
                _InlineError(message: errorMessage),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ExpenseListSection(expenses: recentExpenses),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddExpenseSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
      ),
    );
  }
}
