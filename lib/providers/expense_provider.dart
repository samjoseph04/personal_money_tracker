import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/services/hive_service.dart';
import 'package:personal_money_tracker/utils/amount_parser.dart';
import 'package:personal_money_tracker/utils/app_date_utils.dart';
import 'package:personal_money_tracker/utils/expense_insights.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider({HiveService? service})
      : _service = service ?? HiveService.instance;

  final HiveService _service;
  final List<Expense> _expenses = [];
  late final UnmodifiableListView<Expense> _recentExpensesView =
      UnmodifiableListView(_expenses);

  bool _isLoading = false;
  String? _errorMessage;
  double _todayTotal = 0;
  ExpenseInsightSummary _insights = const ExpenseInsightSummary.empty();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get todayTotal => _todayTotal;
  ExpenseInsightSummary get insights => _insights;
  UnmodifiableListView<Expense> get recentExpenses => _recentExpensesView;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final items = await _service.fetchExpenses();
      _expenses
        ..clear()
        ..addAll(items);
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
    required ExpenseCategory category,
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

  void _recalculateDerivedState() {
    final now = DateTime.now();

    _todayTotal = _expenses
        .where((expense) => AppDateUtils.isSameDay(expense.createdAt, now))
        .fold(0.0, (total, expense) => total + expense.amount);

    _insights = ExpenseInsights.summarize(_expenses);
  }
}
