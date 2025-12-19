import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/currency_rate.dart';

class CurrencyService {
  static Future<CurrencyRate?> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    try {
      final url =
          '${ApiConfig.currencyBaseUrl}/${ApiConfig.currencyApiKey}/latest/$fromCurrency';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == 'success') {
          final rawRate = data['conversion_rates'][toCurrency];
          if (rawRate is num) {
            return CurrencyRate(
              rate: rawRate.toDouble(),
              from: fromCurrency,
              to: toCurrency,
              timestamp: DateTime.now(),
            );
          }
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching exchange rate: $e');
      return null;
    }
  }

  static List<String> get supportedCurrencies => [
    'BDT',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR',
    'MXN',
  ];
}
