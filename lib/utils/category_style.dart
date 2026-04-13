import 'package:flutter/material.dart';

import 'package:personal_money_tracker/models/expense.dart';

@immutable
class CategoryPreset {
  const CategoryPreset({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
  });

  final String id;
  final String name;
  final int iconCodePoint;
  final int colorValue;
}

const List<CategoryPreset> categoryPresets = [
  CategoryPreset(
    id: 'default_food',
    name: 'Food',
    iconCodePoint: Icons.restaurant_rounded.codePoint,
    colorValue: 0xFF5E9C76,
  ),
  CategoryPreset(
    id: 'default_travel',
    name: 'Travel',
    iconCodePoint: Icons.directions_car_filled_rounded.codePoint,
    colorValue: 0xFF4A86C5,
  ),
  CategoryPreset(
    id: 'default_shopping',
    name: 'Shopping',
    iconCodePoint: Icons.shopping_bag_rounded.codePoint,
    colorValue: 0xFFC26E5A,
  ),
  CategoryPreset(
    id: 'default_bills',
    name: 'Bills',
    iconCodePoint: Icons.receipt_long_rounded.codePoint,
    colorValue: 0xFF8B6DB2,
  ),
];

List<ExpenseCategoryData> buildDefaultCategories() {
  return List<ExpenseCategoryData>.generate(categoryPresets.length, (index) {
    final preset = categoryPresets[index];
    return ExpenseCategoryData(
      id: preset.id,
      name: preset.name,
      iconCodePoint: preset.iconCodePoint,
      colorValue: preset.colorValue,
      createdAt: DateTime(2026, 1, index + 1),
    );
  }, growable: false);
}

CategoryPreset presetForCategoryIndex(int index) {
  return categoryPresets[index % categoryPresets.length];
}

ExpenseCategoryData categoryFromLegacy(LegacyExpenseCategory category) {
  switch (category) {
    case LegacyExpenseCategory.food:
      return buildDefaultCategories()[0];
    case LegacyExpenseCategory.travel:
      return buildDefaultCategories()[1];
    case LegacyExpenseCategory.shopping:
      return buildDefaultCategories()[2];
    case LegacyExpenseCategory.bills:
      return buildDefaultCategories()[3];
  }
}

extension ExpenseCategoryStyle on ExpenseCategoryData {
  String get label {
    return name;
  }

  IconData get icon {
    return IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  }

  Color get color {
    return Color(colorValue);
  }
}
