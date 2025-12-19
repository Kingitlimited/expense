import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import 'transaction_service.dart';

class AddTransactionProvider extends ChangeNotifier {
  String _type = 'expense';
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _amountText = '';
  String _noteText = '';

  final List<String> _categories = [
    'Groceries',
    'Transportation',
    'Shopping',
    'Bills',
    'Food & Dining',
    'Entertainment',
    'Salary',
    'Freelance',
    'Investments',
    'Other',
  ];

  String get type => _type;
  String? get selectedCategory => _selectedCategory;
  DateTime get selectedDate => _selectedDate;
  String get amountText => _amountText;
  String get noteText => _noteText;
  List<String> get categories => List.unmodifiable(_categories);

  void setType(String value) {
    if (value == _type) return;
    _type = value;
    if (_type == 'income') {
      _selectedCategory = null;
    }
    notifyListeners();
  }

  void setCategory(String? value) {
    if (value == _selectedCategory) return;
    _selectedCategory = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    if (date == _selectedDate) return;
    _selectedDate = date;
    notifyListeners();
  }

  void setAmountText(String value) {
    if (value == _amountText) return;
    _amountText = value;
    notifyListeners();
  }

  void setNoteText(String value) {
    if (value == _noteText) return;
    _noteText = value;
    notifyListeners();
  }

  String? submit(TransactionService service) {
    if (_amountText.isEmpty || (_type == 'expense' && _selectedCategory == null)) {
      return 'Please fill all fields';
    }

    final parsedAmount = double.tryParse(_amountText);
    if (parsedAmount == null) {
      return 'Please enter a valid amount';
    }

    final transaction = Transaction(
      id: Random().nextInt(100000).toString(),
      type: _type,
      amount: parsedAmount,
      category: _selectedCategory ?? 'Income',
      date: _selectedDate,
      note: _noteText.isEmpty ? null : _noteText,
    );

    service.addTransaction(transaction);
    reset();
    return null;
  }

  void reset() {
    _type = 'expense';
    _selectedCategory = null;
    _selectedDate = DateTime.now();
    _amountText = '';
    _noteText = '';
    notifyListeners();
  }
}
