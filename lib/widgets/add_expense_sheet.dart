import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:personal_money_tracker/models/expense.dart';
import 'package:personal_money_tracker/providers/expense_provider.dart';
import 'package:personal_money_tracker/utils/category_style.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _amountFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final categories = context.select(
      (ExpenseProvider value) => value.categories,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, bottomInset + 12),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick add',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Type an amount, then tap a category to save instantly.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    style: Theme.of(context).textTheme.headlineSmall,
                    decoration: const InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '₹ ',
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (categories.isEmpty)
                    Text(
                      'Add a category first to start logging expenses.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories
                          .map(
                            (category) => _CategoryButton(
                              category: category,
                              isSaving: _isSaving,
                              onTap: () => _saveExpense(context, category),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveExpense(
    BuildContext context,
    ExpenseCategoryData category,
  ) async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final error = await context.read<ExpenseProvider>().addExpense(
      amountText: _amountController.text,
      category: category,
    );

    if (!mounted) {
      return;
    }

    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.isSaving,
    required this.onTap,
  });

  final ExpenseCategoryData category;
  final bool isSaving;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isSaving ? null : onTap,
      icon: Icon(category.icon),
      label: Text(category.label),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        backgroundColor: category.color.withOpacity(0.12),
        foregroundColor: category.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
