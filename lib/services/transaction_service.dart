import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionService extends ChangeNotifier {
  static const String _storageKey = 'transactions';

  List<Transaction> _transactions = [
    Transaction(
      id: '1',
      type: 'expense',
      amount: 850,
      category: 'Groceries',
      date: DateTime(2025, 12, 12),
      note: 'Weekly groceries',
    ),
    Transaction(
      id: '2',
      type: 'income',
      amount: 45000,
      category: 'Salary',
      date: DateTime(2025, 12, 10),
      note: 'Monthly salary',
    ),
  ];

  TransactionService() {
    _loadFromPrefs();
  }

  List<Transaction> get transactions => _transactions;

  double get totalBalance {
    double balance = 0;
    for (var t in _transactions) {
      if (t.type == 'income') {
        balance += t.amount;
      } else {
        balance -= t.amount;
      }
    }
    return balance;
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Transaction> get recentTransactions {
    final sorted = [..._transactions]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
    _saveToPrefs();
  }

  void updateTransaction(Transaction transaction) {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
      _saveToPrefs();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
    _saveToPrefs();
  }

  Map<String, double> getExpensesByCategory() {
    Map<String, double> categories = {};
    for (var t in _transactions.where((t) => t.type == 'expense')) {
      categories[t.category] = (categories[t.category] ?? 0) + t.amount;
    }
    return categories;
  }

  Map<String, double> getExpensesByCategoryForPeriod(String period) {
    Map<String, double> categories = {};
    for (var t in filterByPeriod(period).where((t) => t.type == 'expense')) {
      categories[t.category] = (categories[t.category] ?? 0) + t.amount;
    }
    return categories;
  }

  List<Transaction> filterByPeriod(String period) {
    final now = DateTime.now();
    return _transactions.where((t) {
      if (period == 'week') {
        return t.date.isAfter(now.subtract(const Duration(days: 7)));
      } else if (period == 'month') {
        return t.date.month == now.month && t.date.year == now.year;
      } else if (period == 'year') {
        return t.date.year == now.year;
      }
      return true;
    }).toList();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_storageKey)) {
        final data = _transactions.map((t) => t.toJson()).toList();
        await prefs.setString(_storageKey, jsonEncode(data));
        return;
      }
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null) return;
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return;
      _transactions = decoded
          .whereType<Map>()
          .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading transactions: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _transactions.map((t) => t.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
      // ignore: avoid_print
      print('Error saving transactions: $e');
    }
  }
}
