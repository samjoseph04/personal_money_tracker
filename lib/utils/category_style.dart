import 'package:flutter/material.dart';

import 'package:personal_money_tracker/models/expense.dart';

extension ExpenseCategoryStyle on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.travel:
        return Icons.directions_car_filled_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.bills:
        return Icons.receipt_long_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return const Color(0xFF5E9C76);
      case ExpenseCategory.travel:
        return const Color(0xFF4A86C5);
      case ExpenseCategory.shopping:
        return const Color(0xFFC26E5A);
      case ExpenseCategory.bills:
        return const Color(0xFF8B6DB2);
    }
  }
}
