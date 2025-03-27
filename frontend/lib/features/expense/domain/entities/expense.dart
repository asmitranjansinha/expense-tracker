// expense.dart
class Expense {
  final String id;
  final double amount;
  final String beneficiary;
  final String category;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.beneficiary,
    required this.category,
    this.description,
    required this.date,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'],
      amount: json['amount'].toDouble(),
      beneficiary: json['beneficiary'],
      category: json['category'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'beneficiary': beneficiary,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
