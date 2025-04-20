import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'transfer.dart'; // Import the TransferScreen

class FavoritesScreen extends StatefulWidget {
  final int userId; // User ID passed from login or session
  final Function refreshUserData; // Add this parameter
  final Function refreshCardData; // Add this parameter

  FavoritesScreen({
    required this.userId,
    required this.refreshUserData, // Initialize this parameter
    required this.refreshCardData, // Initialize this parameter
  });

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<dynamic> favorites = []; // To store favorite accounts

  // Function to fetch the favorites from the API
  Future<void> _getFavorites() async {
    final response = await http.post(
      Uri.parse('http://192.168.68.112/api_bank/api/get_favorites.php'), // Use your actual API URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': widget.userId}), // Send user ID to get favorites
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          favorites = data['favorites']; // Update the favorites list
        });
      } else {
        // Handle no favorites or API errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      // Handle API errors like connection issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorites.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getFavorites(); // Fetch the favorites when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            // List the favorites
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return ListTile(
                    title: Text(favorite['bank_name']),
                    subtitle: Text(favorite['account_number']),
                    onTap: () {
                      // Navigate to TransferScreen with selected favorite's data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferScreen(
                            userId: widget.userId,
                            selectedBank: favorite['bank_name'],
                            recipientAccount: favorite['account_number'],
                            recipientName: favorite['account_name'],
                            favorite: favorite,
                            refreshUserData: widget.refreshUserData, // Pass the refreshUserData function
                            refreshCardData: widget.refreshCardData, // Pass the refreshCardData function
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
