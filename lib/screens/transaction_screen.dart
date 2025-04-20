import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://atmgo.site/api/';

  // Login
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
      print('Error in login: $e');
      throw Exception('Login failed: $e');
    }
  }

  // Register
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
      print('Error in register: $e');
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
      return jsonDecode(response.body);
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
      print('Error in getTransactionHistory: $e');
      throw Exception('Failed to load transaction history: $e');
    }
  }

  // Change Password
  static Future<void> changePassword(int userId, String oldPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password.php'),
        body: {
          'user_id': userId.toString(),
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in changePassword: $e');
      throw Exception('Failed to change password: $e');
    }
  }

  // Add Favorite
  static Future<void> addFavorite(int userId, String bankName, String accountName, String accountNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_favorite.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'bank_name': bankName,
          'account_name': accountName,
          'account_number': accountNumber,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in addFavorite: $e');
      throw Exception('Failed to add favorite: $e');
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

  static Future<Map<String, dynamic>> transferFunds(int userId, String recipientAccount, double amount, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transfer.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'recipient_account': recipientAccount,
        'amount': amount,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Transfer failed: ${response.body}');
    }
  }

  // Pay Bill
  static Future<void> payBill(int userId, String billType, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pay_bill.php'),
        body: {
          'user_id': userId.toString(),
          'bill_type': billType,
          'amount': amount.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Bill payment failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in payBill: $e');
      throw Exception('Bill payment failed: $e');
    }
  }
}
