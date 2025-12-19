class Transaction {
  final String id;
  final String type; // 'income' or 'expense'
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'note': note,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    type: json['type'],
    amount: json['amount'].toDouble(),
    category: json['category'],
    date: DateTime.parse(json['date']),
    note: json['note'],
  );
}
