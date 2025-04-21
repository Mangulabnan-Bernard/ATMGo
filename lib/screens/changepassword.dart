import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'forgot_password_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userId;

  ChangePasswordScreen({required this.userId});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;

    try {
      final response = await ApiService.changePassword(widget.userId, oldPassword, newPassword);
      if (response['message'] == 'Password changed successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showForgotPasswordModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ForgotPasswordModal();
      },
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                decoration: InputDecoration(labelText: 'Old Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter old password' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter new password' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Confirm new password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _showForgotPasswordModal,
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
