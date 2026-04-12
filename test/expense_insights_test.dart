import 'package:flutter_test/flutter_test.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/utils/expense_insights.dart';

void main() {
  group('ExpenseInsights', () {
    test('returns empty state for no expenses', () {
      final summary = ExpenseInsights.summarize([]);

      expect(summary.topCategory, isNull);
      expect(summary.topCategoryTotal, 0);
      expect(summary.categoryTotals[ExpenseCategory.food], 0);
      expect(summary.categoryTotals[ExpenseCategory.travel], 0);
    });

    test('summarizes category totals and top category', () {
      final expenses = [
        Expense.create(
          amount: 50,
          category: ExpenseCategory.food,
          createdAt: DateTime(2026, 4, 10, 9),
        ),
        Expense.create(
          amount: 80,
          category: ExpenseCategory.travel,
          createdAt: DateTime(2026, 4, 10, 12),
        ),
        Expense.create(
          amount: 25,
          category: ExpenseCategory.food,
          createdAt: DateTime(2026, 4, 10, 18),
        ),
      ];

      final summary = ExpenseInsights.summarize(expenses);

      expect(summary.categoryTotals[ExpenseCategory.food], 75);
      expect(summary.categoryTotals[ExpenseCategory.travel], 80);
      expect(summary.categoryTotals[ExpenseCategory.shopping], 0);
      expect(summary.topCategory, ExpenseCategory.travel);
      expect(summary.topCategoryTotal, 80);
    });
  });
}
