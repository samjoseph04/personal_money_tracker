class AmountParser {
  const AmountParser._();

  static double? tryParsePositive(String value) {
    final normalized = value.trim().replaceAll(',', '');
    final parsed = double.tryParse(normalized);

    if (parsed == null || parsed <= 0) {
      return null;
    }

    return double.parse(parsed.toStringAsFixed(2));
  }
}
