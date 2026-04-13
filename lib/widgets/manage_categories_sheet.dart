import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_money_tracker/providers/expense_provider.dart';
import 'package:personal_money_tracker/utils/category_style.dart';

class ManageCategoriesSheet extends StatefulWidget {
  const ManageCategoriesSheet({super.key});

  @override
  State<ManageCategoriesSheet> createState() => _ManageCategoriesSheetState();
}

class _ManageCategoriesSheetState extends State<ManageCategoriesSheet> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
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
                    'Manage categories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add new categories or remove old ones. Past expenses keep their original category name.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addCategory(context),
                          decoration: const InputDecoration(
                            hintText: 'New category name',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _addCategory(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _CategoryRow(
                        label: category.label,
                        icon: category.icon,
                        color: category.color,
                        onDelete: _isSubmitting
                            ? null
                            : () => _deleteCategory(context, category.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addCategory(BuildContext context) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final error = await context.read<ExpenseProvider>().addCategory(
      nameText: _nameController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (error == null) {
      _nameController.clear();
      _nameFocusNode.requestFocus();
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _deleteCategory(BuildContext context, String categoryId) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final error = await context.read<ExpenseProvider>().deleteCategory(
      categoryId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.icon,
    required this.color,
    required this.onDelete,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete category',
          ),
        ],
      ),
    );
  }
}
