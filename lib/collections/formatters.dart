import 'package:intl/intl.dart';

final compactNumberFormatter = NumberFormat.compact();
final usdFormatter = NumberFormat.compactCurrency(
  locale: 'en-US',
  symbol: r"$",
  decimalDigits: 2,
);
