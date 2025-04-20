class TransactionModel {
  final String description;
  final String type;
  final double amount;
  final String createdAt;

  TransactionModel({
    required this.description,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      description: json['description'],
      type: json['type'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0, // Handle string to double conversion
      createdAt: json['created_at'],
    );
  }
}
