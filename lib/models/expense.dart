import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

@immutable
class ExpenseCategoryData {
  const ExpenseCategoryData({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    required this.createdAt,
  });

  factory ExpenseCategoryData.create({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    DateTime? createdAt,
  }) {
    final timestamp = createdAt ?? DateTime.now();
    return ExpenseCategoryData(
      id: 'category_${timestamp.microsecondsSinceEpoch}',
      name: name,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      createdAt: timestamp,
    );
  }

  final String id;
  final String name;
  final int iconCodePoint;
  final int colorValue;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ExpenseCategoryData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@immutable
class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.createdAt,
  });

  factory Expense.create({
    required double amount,
    required ExpenseCategoryData category,
    DateTime? createdAt,
  }) {
    final timestamp = createdAt ?? DateTime.now();
    return Expense(
      id: timestamp.microsecondsSinceEpoch.toString(),
      amount: amount,
      category: category,
      createdAt: timestamp,
    );
  }

  final String id;
  final double amount;
  final ExpenseCategoryData category;
  final DateTime createdAt;
}

class ExpenseCategoryDataAdapter extends TypeAdapter<ExpenseCategoryData> {
  @override
  final int typeId = 2;

  @override
  ExpenseCategoryData read(BinaryReader reader) {
    return ExpenseCategoryData(
      id: reader.readString(),
      name: reader.readString(),
      iconCodePoint: reader.readInt(),
      colorValue: reader.readInt(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseCategoryData obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.iconCodePoint);
    writer.writeInt(obj.colorValue);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 3;

  @override
  Expense read(BinaryReader reader) {
    return Expense(
      id: reader.readString(),
      amount: reader.readDouble(),
      category: reader.read() as ExpenseCategoryData,
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.write(obj.category);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

enum LegacyExpenseCategory { food, travel, shopping, bills }

@immutable
class LegacyExpense {
  const LegacyExpense({
    required this.id,
    required this.amount,
    required this.category,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final LegacyExpenseCategory category;
  final DateTime createdAt;
}

class LegacyExpenseCategoryAdapter extends TypeAdapter<LegacyExpenseCategory> {
  @override
  final int typeId = 0;

  @override
  LegacyExpenseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LegacyExpenseCategory.food;
      case 1:
        return LegacyExpenseCategory.travel;
      case 2:
        return LegacyExpenseCategory.shopping;
      case 3:
        return LegacyExpenseCategory.bills;
      default:
        return LegacyExpenseCategory.food;
    }
  }

  @override
  void write(BinaryWriter writer, LegacyExpenseCategory obj) {
    writer.writeByte(obj.index);
  }
}

class LegacyExpenseAdapter extends TypeAdapter<LegacyExpense> {
  @override
  final int typeId = 1;

  @override
  LegacyExpense read(BinaryReader reader) {
    return LegacyExpense(
      id: reader.readString(),
      amount: reader.readDouble(),
      category: reader.read() as LegacyExpenseCategory,
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, LegacyExpense obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.write(obj.category);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
