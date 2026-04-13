import 'package:flutter_test/flutter_test.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/utils/expense_insights.dart';

void main() {
  group('ExpenseInsights', () {
    final food = ExpenseCategoryData(
      id: 'food',
      name: 'Food',
      iconCodePoint: 1,
      colorValue: 0xFF5E9C76,
      createdAt: DateTime(2026, 1, 1),
    );
    final travel = ExpenseCategoryData(
      id: 'travel',
      name: 'Travel',
      iconCodePoint: 2,
      colorValue: 0xFF4A86C5,
      createdAt: DateTime(2026, 1, 2),
    );
    final shopping = ExpenseCategoryData(
      id: 'shopping',
      name: 'Shopping',
      iconCodePoint: 3,
      colorValue: 0xFFC26E5A,
      createdAt: DateTime(2026, 1, 3),
    );

    test('returns empty state for no expenses', () {
      final summary = ExpenseInsights.summarize([], categories: [food, travel]);

      expect(summary.topCategory, isNull);
      expect(summary.topCategoryTotal, 0);
      expect(summary.categoryTotals[food], 0);
      expect(summary.categoryTotals[travel], 0);
    });

    test('summarizes category totals and top category', () {
      final expenses = [
        Expense.create(
          amount: 50,
          category: food,
          createdAt: DateTime(2026, 4, 10, 9),
        ),
        Expense.create(
          amount: 80,
          category: travel,
          createdAt: DateTime(2026, 4, 10, 12),
        ),
        Expense.create(
          amount: 25,
          category: food,
          createdAt: DateTime(2026, 4, 10, 18),
        ),
      ];

      final summary = ExpenseInsights.summarize(
        expenses,
        categories: [food, travel, shopping],
      );

      expect(summary.categoryTotals[food], 75);
      expect(summary.categoryTotals[travel], 80);
      expect(summary.categoryTotals[shopping], 0);
      expect(summary.topCategory, travel);
      expect(summary.topCategoryTotal, 80);
    });
  });
}
