import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:personal_money_tracker/models/expense.dart';

@immutable
class ExpenseInsightSummary {
  const ExpenseInsightSummary({
    required this.categoryTotals,
    required this.topCategory,
    required this.topCategoryTotal,
  });

  const ExpenseInsightSummary.empty()
    : categoryTotals = const {},
      topCategory = null,
      topCategoryTotal = 0;

  final Map<ExpenseCategoryData, double> categoryTotals;
  final ExpenseCategoryData? topCategory;
  final double topCategoryTotal;

  UnmodifiableListView<MapEntry<ExpenseCategoryData, double>> get sortedTotals {
    final entries = categoryTotals.entries.toList()
      ..sort((left, right) {
        final totalComparison = right.value.compareTo(left.value);
        if (totalComparison != 0) {
          return totalComparison;
        }

        return left.key.name.toLowerCase().compareTo(
          right.key.name.toLowerCase(),
        );
      });
    return UnmodifiableListView(entries);
  }
}

class ExpenseInsights {
  const ExpenseInsights._();

  static ExpenseInsightSummary summarize(
    List<Expense> expenses, {
    Iterable<ExpenseCategoryData> categories = const [],
  }) {
    final totals = <ExpenseCategoryData, double>{
      for (final category in categories) category: 0,
    };

    for (final expense in expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    ExpenseCategoryData? topCategory;
    double topCategoryTotal = 0;

    for (final entry in totals.entries) {
      if (entry.value > topCategoryTotal) {
        topCategory = entry.key;
        topCategoryTotal = entry.value;
      }
    }

    if (topCategoryTotal == 0) {
      topCategory = null;
    }

    return ExpenseInsightSummary(
      categoryTotals: Map.unmodifiable(totals),
      topCategory: topCategory,
      topCategoryTotal: topCategoryTotal,
    );
  }
}
