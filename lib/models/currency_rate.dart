class CurrencyRate {
  CurrencyRate({
    required this.rate,
    required this.from,
    required this.to,
    required this.timestamp,
  });

  final double rate;
  final String from;
  final String to;
  final DateTime timestamp;
}
