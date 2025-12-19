import 'package:flutter/foundation.dart';

class AnalyticsProvider extends ChangeNotifier {
  String _selectedPeriod = 'week';

  String get selectedPeriod => _selectedPeriod;

  void setPeriod(String value) {
    if (value == _selectedPeriod) return;
    _selectedPeriod = value;
    notifyListeners();
  }
}
