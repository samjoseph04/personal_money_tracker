import 'package:hive_flutter/hive_flutter.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/utils/category_style.dart';

class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();
  static const String _expenseBoxName = 'coinflow_expenses_box';
  static const String _categoryBoxName = 'coinflow_categories_box';
  static const String _legacyExpenseBoxName = 'expenses_box';

  Box<Expense>? _expenseBox;
  Box<ExpenseCategoryData>? _categoryBox;

  Future<void> init() async {
    if (_expenseBox != null && _categoryBox != null) {
      return;
    }

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(LegacyExpenseCategoryAdapter().typeId)) {
      Hive.registerAdapter(LegacyExpenseCategoryAdapter());
    }

    if (!Hive.isAdapterRegistered(LegacyExpenseAdapter().typeId)) {
      Hive.registerAdapter(LegacyExpenseAdapter());
    }

    if (!Hive.isAdapterRegistered(ExpenseCategoryDataAdapter().typeId)) {
      Hive.registerAdapter(ExpenseCategoryDataAdapter());
    }

    if (!Hive.isAdapterRegistered(ExpenseAdapter().typeId)) {
      Hive.registerAdapter(ExpenseAdapter());
    }

    _categoryBox = await Hive.openBox<ExpenseCategoryData>(_categoryBoxName);
    _expenseBox = await Hive.openBox<Expense>(_expenseBoxName);

    await _migrateLegacyDataIfNeeded();
    await _seedDefaultCategoriesIfNeeded();
  }

  Future<List<Expense>> fetchExpenses() async {
    final items = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<List<ExpenseCategoryData>> fetchCategories() async {
    final items = _categoryBoxRef.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  Future<void> addCategory(ExpenseCategoryData category) async {
    await _categoryBoxRef.put(category.id, category);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryBoxRef.delete(categoryId);
  }

  Future<void> _migrateLegacyDataIfNeeded() async {
    if (_box.isNotEmpty || _categoryBoxRef.isNotEmpty) {
      return;
    }

    if (!await Hive.boxExists(_legacyExpenseBoxName)) {
      return;
    }

    final legacyBox = await Hive.openBox<LegacyExpense>(_legacyExpenseBoxName);
    if (legacyBox.isEmpty) {
      await legacyBox.close();
      return;
    }

    final defaultCategories = buildDefaultCategories();
    await _categoryBoxRef.putAll({
      for (final category in defaultCategories) category.id: category,
    });

    await _box.putAll({
      for (final legacyExpense in legacyBox.values)
        legacyExpense.id: Expense(
          id: legacyExpense.id,
          amount: legacyExpense.amount,
          category: categoryFromLegacy(legacyExpense.category),
          createdAt: legacyExpense.createdAt,
        ),
    });

    await legacyBox.close();
  }

  Future<void> _seedDefaultCategoriesIfNeeded() async {
    if (_categoryBoxRef.isNotEmpty) {
      return;
    }

    final defaultCategories = buildDefaultCategories();
    await _categoryBoxRef.putAll({
      for (final category in defaultCategories) category.id: category,
    });
  }

  Box<Expense> get _box {
    final box = _expenseBox;
    if (box == null) {
      throw StateError('HiveService.init() must be called before use.');
    }
    return box;
  }

  Box<ExpenseCategoryData> get _categoryBoxRef {
    final box = _categoryBox;
    if (box == null) {
      throw StateError('HiveService.init() must be called before use.');
    }
    return box;
  }
}
