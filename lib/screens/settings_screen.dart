import 'package:atm_go/screens/privacy.dart';
import 'package:atm_go/screens/userprofile.dart'; // Import UserProfileScreen
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
              onTap: () => logout(),
            ),
          ],
        ),
      ),
    );
  }
}
