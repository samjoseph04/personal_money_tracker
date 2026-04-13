import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/services/hive_service.dart';
import 'package:personal_money_tracker/utils/amount_parser.dart';
import 'package:personal_money_tracker/utils/app_date_utils.dart';
import 'package:personal_money_tracker/utils/category_style.dart';
import 'package:personal_money_tracker/utils/expense_insights.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider({HiveService? service})
    : _service = service ?? HiveService.instance;

  final HiveService _service;
  final List<Expense> _expenses = [];
  final List<ExpenseCategoryData> _categories = [];
  late final UnmodifiableListView<Expense> _recentExpensesView =
      UnmodifiableListView(_expenses);
  late final UnmodifiableListView<ExpenseCategoryData> _categoriesView =
      UnmodifiableListView(_categories);

  bool _isLoading = false;
  String? _errorMessage;
  double _todayTotal = 0;
  ExpenseInsightSummary _insights = const ExpenseInsightSummary.empty();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get todayTotal => _todayTotal;
  ExpenseInsightSummary get insights => _insights;
  UnmodifiableListView<Expense> get recentExpenses => _recentExpensesView;
  UnmodifiableListView<ExpenseCategoryData> get categories => _categoriesView;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>([
        _service.fetchExpenses(),
        _service.fetchCategories(),
      ]);

      final items = results[0] as List<Expense>;
      final categories = results[1] as List<ExpenseCategoryData>;

      _expenses
        ..clear()
        ..addAll(items);
      _categories
        ..clear()
        ..addAll(categories);
      _errorMessage = null;
      _recalculateDerivedState();
    } catch (_) {
      _errorMessage = 'Unable to load your expenses right now.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addExpense({
    required String amountText,
    required ExpenseCategoryData category,
  }) async {
    final amount = AmountParser.tryParsePositive(amountText);
    if (amount == null) {
      return 'Enter a valid amount greater than zero.';
    }

    try {
      final expense = Expense.create(amount: amount, category: category);
      await _service.addExpense(expense);
      _expenses.insert(0, expense);
      _errorMessage = null;
      _recalculateDerivedState();
      notifyListeners();
      return null;
    } catch (_) {
      return 'Your expense could not be saved. Please try again.';
    }
  }

  Future<String?> addCategory({required String nameText}) async {
    final normalized = _normalizeCategoryName(nameText);
    if (normalized.isEmpty) {
      return 'Enter a category name.';
    }

    final alreadyExists = _categories.any(
      (category) => _normalizeCategoryName(category.name) == normalized,
    );
    if (alreadyExists) {
      return 'That category already exists.';
    }

    try {
      final preset = presetForCategoryIndex(_categories.length);
      final category = ExpenseCategoryData.create(
        name: _toDisplayName(normalized),
        iconCodePoint: preset.iconCodePoint,
        colorValue: preset.colorValue,
      );

      await _service.addCategory(category);
      _categories.add(category);
      _errorMessage = null;
      _recalculateDerivedState();
      notifyListeners();
      return null;
    } catch (_) {
      return 'Your category could not be saved. Please try again.';
    }
  }

  Future<String?> deleteCategory(String categoryId) async {
    if (_categories.length <= 1) {
      return 'Keep at least one category so you can continue logging expenses.';
    }

    final index = _categories.indexWhere(
      (category) => category.id == categoryId,
    );
    if (index == -1) {
      return 'This category no longer exists.';
    }

    try {
      await _service.deleteCategory(categoryId);
      _categories.removeAt(index);
      _errorMessage = null;
      _recalculateDerivedState();
      notifyListeners();
      return null;
    } catch (_) {
      return 'This category could not be deleted. Please try again.';
    }
  }

  void _recalculateDerivedState() {
    final now = DateTime.now();

    _todayTotal = _expenses
        .where((expense) => AppDateUtils.isSameDay(expense.createdAt, now))
        .fold(0.0, (total, expense) => total + expense.amount);

    _insights = ExpenseInsights.summarize(_expenses, categories: _categories);
  }

  String _normalizeCategoryName(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  String _toDisplayName(String value) {
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
