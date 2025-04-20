class UserModel {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String email;
  final String mobileNumber;
  final String birthdate;

  UserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.birthdate,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'] ?? 0,
      firstName: map['first_name'] ?? '',
      middleName: map['middle_name'] ?? '',
      lastName: map['last_name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobile_number'] ?? '',
      birthdate: map['birthdate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'mobile_number': mobileNumber,
      'birthdate': birthdate,
    };
  }
}
