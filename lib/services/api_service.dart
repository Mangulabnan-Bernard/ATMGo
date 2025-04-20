import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://atmgo.site/api/';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registration failed: ${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  static Future<Map<String, dynamic>> getDashboardData(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_dashboard_data.php'),
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Dashboard Data Response: $data'); // Debug log

      // Provide default values if keys are missing
      return {
        'user': data['user'] ?? {
          'user_id': 0,
          'first_name': 'User',
          'middle_name': '',
          'last_name': '',
          'username': '',
          'email': '',
          'mobile_number': '',
          'birthdate': '',
        },
        'card': data['card'] ?? {'balance': 0.0},
        'transactions': data['transactions'] ?? [],
      };
    } else {
      throw Exception('Failed to fetch dashboard data');
    }
  }

  static Future<List<dynamic>> getTransactionHistory(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_transaction_history.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load transaction history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load transaction history: $e');
    }
  }

  static Future<Map<String, dynamic>> getCardData(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate_card.php'),
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch card data');
    }
  }

  static Future<void> cashIn(int userId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cash_in.php'),
      body: jsonEncode({'user_id': userId, 'amount': amount}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cash in');
    }
  }

  static Future<Map<String, dynamic>> transferFunds(int userId, String recipientAccount, double amount, String bankName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transfer.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'recipient_account': recipientAccount,
          'amount': amount,
          'bank_name': bankName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Transfer failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Transfer failed: $e');
    }
  }

  static Future<void> addFavorite(int userId, String bankName, String accountName, String accountNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_favorites.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'bank_name': bankName,
          'account_name': accountName,
          'account_number': accountNumber,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add favorite');
      }
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  static Future<Map<String, dynamic>> payBill(int userId, String billType, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pay_bill.php'),
        body: jsonEncode({
          'user_id': userId,
          'bill_type': billType,
          'amount': amount,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Bill payment failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bill payment failed: $e');
    }
  }

  static Future<Map<String, dynamic>> changePassword(int userId, String oldPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Password change failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  static Future<Map<String, dynamic>> validateOldPassword(int userId, String oldPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate_old_password.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'old_password': oldPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Password validation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Password validation failed: $e');
    }
  }


  static Future<void> updateUserData(Map<String, dynamic> userData) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/profile_update.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        if (response.statusCode != 200) {
          print('Failed to update user data: ${response.statusCode}');
          throw Exception('Failed to update user data: ${response.statusCode}');
        }

        print('User data updated successfully');
      } catch (e) {
        print('Exception occurred: $e');
        throw Exception('Failed to update user data: $e');
      }
    }
}
