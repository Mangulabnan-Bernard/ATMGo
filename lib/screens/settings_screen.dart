import 'package:atm_go/screens/privacy.dart';
import 'package:atm_go/screens/userprofile.dart'; // Import UserProfileScreen
import 'package:atm_go/screens/favorites.dart'; // Import FavoritesScreen
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'about.dart';
import 'changepassword.dart';
import 'aboutatmgo.dart';

class SettingsScreen extends StatelessWidget {
  final UserModel user;
  final Function logout;
  final Function refreshUserData;
  final Function refreshCardData;

  SettingsScreen({
    required this.user,
    required this.logout,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if "No" is pressed
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if "Yes" is pressed
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Divider(),
            ListTile(
              title: Text('Profile'), // New Profile ListTile
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(
                      user: user,
                      refreshUserData: refreshUserData,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Favorites'), // New Favorites ListTile
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(
                      userId: user.id,
                      refreshUserData: refreshUserData,
                      refreshCardData: refreshCardData,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(userId: user.id),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                // Show a confirmation dialog first
                bool confirmLogout = await _showLogoutDialog(context);
                if (confirmLogout) {
                  logout();
                }
              },
            ),
            ListTile(
              title: Text('Version: 1.0.0+12'), // Add version label here
              enabled: false, // Disable the tile to make it non-interactive
            ),
          ],


        ),
      ),
    );
  }
}
