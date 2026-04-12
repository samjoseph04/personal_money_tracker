import 'package:intl/intl.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(double amount) {
    final hasWholeValue = amount == amount.roundToDouble();
    return NumberFormat.simpleCurrency(
      decimalDigits: hasWholeValue ? 0 : 2,
    ).format(amount);
  }
}
