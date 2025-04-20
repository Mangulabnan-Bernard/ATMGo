class CardModel {
  final int id;
  final int userId;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final double balance;
  final String firstName;
  final String lastName;

  CardModel({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.balance,
    required this.firstName,
    required this.lastName,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      userId: json['user_id'],
      cardNumber: json['card_number'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      cvv: json['cvv'] ?? '',
      balance: json['balance']?.toDouble() ?? 0.0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'balance': balance,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
