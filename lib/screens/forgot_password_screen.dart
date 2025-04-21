import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgotPasswordModal extends StatefulWidget {
  @override
  _ForgotPasswordModalState createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String? _email;
  bool _isOtpSent = false;
  bool _isOtpVerified = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    setState(() {
      _email = email;
    });

    try {
      final response = await ApiService.sendOtp(email);
      if (response['message'] == 'OTP sent successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent successfully')),
        );
        setState(() {
          _isOtpSent = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otp = _otpController.text.trim(); // Ensure OTP is a string

    try {
      final response = await ApiService.verifyOtp(otp);
      if (response['message'] == 'OTP verified successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verified successfully')),
        );
        setState(() {
          _isOtpVerified = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _newPasswordController.text.trim();

    try {
      final response = await ApiService.resetPassword(
        _email!,               // Pass the email (String)
        _otpController.text,   // Pass the OTP (String)
        newPassword,           // Pass the new password (String)
      );

      if (response['message'] == 'Password reset successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successfully')),
        );

        // Clear any cached data
        await _secureStorage.deleteAll();

        Navigator.of(context).pop(); // Close the modal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset password: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Forgot Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isOtpSent) ...[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              SizedBox(height: 8),
              Text(
                'Make sure to enter the email you used during registration.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendOtp,
                child: Text('Send OTP'),
              ),
            ] else if (!_isOtpVerified) ...[
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
                validator: (value) => value!.isEmpty ? 'Enter OTP' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text('Verify OTP'),
              ),
            ] else ...[
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter new password' : null,
              ),
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
                onPressed: _resetPassword,
                child: Text('Reset Password'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}