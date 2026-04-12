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

  final Map<ExpenseCategory, double> categoryTotals;
  final ExpenseCategory? topCategory;
  final double topCategoryTotal;

  UnmodifiableListView<MapEntry<ExpenseCategory, double>> get sortedTotals {
    final entries = categoryTotals.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));
    return UnmodifiableListView(entries);
  }
}

class ExpenseInsights {
  const ExpenseInsights._();

  static ExpenseInsightSummary summarize(List<Expense> expenses) {
    final totals = <ExpenseCategory, double>{
      for (final category in ExpenseCategory.values) category: 0,
    };

    for (final expense in expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    ExpenseCategory? topCategory;
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
