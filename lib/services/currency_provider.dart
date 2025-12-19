import 'package:flutter/foundation.dart';
import 'currency_service.dart';
import '../models/currency_rate.dart';

class CurrencyProvider extends ChangeNotifier {
  CurrencyProvider() {
    _fetchExchangeRate();
  }

  String _selectedFrom = 'BDT';
  String _selectedTo = 'USD';
  CurrencyRate? _exchangeRate;
  bool _loading = false;
  DateTime? _lastUpdated;
  double? _convertedAmount;
  String? _error;
  double _amount = 1.0;

  String get selectedFrom => _selectedFrom;
  String get selectedTo => _selectedTo;
  CurrencyRate? get exchangeRate => _exchangeRate;
  bool get loading => _loading;
  DateTime? get lastUpdated => _lastUpdated;
  double? get convertedAmount => _convertedAmount;
  String? get error => _error;

  List<String> get supportedCurrencies => CurrencyService.supportedCurrencies;

  void setFrom(String value) {
    if (value == _selectedFrom) return;
    _selectedFrom = value;
    _fetchExchangeRate();
  }

  void setTo(String value) {
    if (value == _selectedTo) return;
    _selectedTo = value;
    _fetchExchangeRate();
  }

  void setAmount(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) {
      _convertedAmount = null;
      notifyListeners();
      return;
    }
    _amount = parsed;
    _calculateConversion();
    notifyListeners();
  }

  void swapCurrencies() {
    final temp = _selectedFrom;
    _selectedFrom = _selectedTo;
    _selectedTo = temp;
    _fetchExchangeRate();
  }

  Future<void> refreshRate() async {
    await _fetchExchangeRate();
  }

  void convert() {
    if (_exchangeRate == null) {
      _fetchExchangeRate();
      return;
    }
    _calculateConversion();
    notifyListeners();
  }

  void _calculateConversion() {
    if (_exchangeRate == null) {
      _convertedAmount = null;
      return;
    }
    _convertedAmount = _amount * _exchangeRate!.rate;
  }

  Future<void> _fetchExchangeRate() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final rate = await CurrencyService.getExchangeRate(_selectedFrom, _selectedTo);
    if (rate != null) {
      _exchangeRate = rate;
      _lastUpdated = DateTime.now();
      _loading = false;
      _calculateConversion();
    } else {
      _exchangeRate = null;
      _convertedAmount = null;
      _loading = false;
      _error = 'Failed to fetch exchange rate';
    }
    notifyListeners();
  }
}
