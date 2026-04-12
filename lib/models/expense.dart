import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum ExpenseCategory {
  food,
  travel,
  shopping,
  bills,
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
    required ExpenseCategory category,
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
  final ExpenseCategory category;
  final DateTime createdAt;
}

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 0;

  @override
  ExpenseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseCategory.food;
      case 1:
        return ExpenseCategory.travel;
      case 2:
        return ExpenseCategory.shopping;
      case 3:
        return ExpenseCategory.bills;
      default:
        return ExpenseCategory.food;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    writer.writeByte(obj.index);
  }
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 1;

  @override
  Expense read(BinaryReader reader) {
    return Expense(
      id: reader.readString(),
      amount: reader.readDouble(),
      category: reader.read() as ExpenseCategory,
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
