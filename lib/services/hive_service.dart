import 'package:hive_flutter/hive_flutter.dart';

import 'package:personal_money_tracker/models/expense.dart';

class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();
  static const String _expenseBoxName = 'expenses_box';

  Box<Expense>? _expenseBox;

  Future<void> init() async {
    if (_expenseBox != null) {
      return;
    }

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(ExpenseCategoryAdapter().typeId)) {
      Hive.registerAdapter(ExpenseCategoryAdapter());
    }

    if (!Hive.isAdapterRegistered(ExpenseAdapter().typeId)) {
      Hive.registerAdapter(ExpenseAdapter());
    }

    _expenseBox = await Hive.openBox<Expense>(_expenseBoxName);
  }

  Future<List<Expense>> fetchExpenses() async {
    final items = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  Box<Expense> get _box {
    final box = _expenseBox;
    if (box == null) {
      throw StateError('HiveService.init() must be called before use.');
    }
    return box;
  }
}
