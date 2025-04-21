import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'forgot_password_screen.dart'; // Import the ForgotPasswordModal

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '', _password = '';
  final LocalAuthentication auth = LocalAuthentication();
  bool _isLoading = false;
  int? _userId; // Store the user ID
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _retrieveUserId();
  }

  Future<void> _retrieveUserId() async {
    String? storedUserId = await _secureStorage.read(key: 'user_id');
    if (storedUserId != null) {
      setState(() {
        _userId = int.parse(storedUserId);
      });
    }
  }

  // Login using Username and Password
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.login(_username, _password);
      if (response['message'] == 'Login successful') {
        setState(() {
          _userId = response['user_id']; // Store the user ID
        });
        await _secureStorage.write(key: 'user_id', value: _userId.toString());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userId: _userId!),
          ),
        );
      } else {
        _showSnackBar('Wrong user or password');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Authenticate with PIN or Fingerprint
  Future<void> _authenticateBiometric() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        if (_userId == null) {
          _showSnackBar('Please log in First, befo'
              're using Biometrics.');
        } else {
          _showSnackBar('Process successful');
          // Navigate to the dashboard or perform any other action
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userId: _userId!),
            ),
          );
        }
      } else {
        _showSnackBar('Authentication failed');
      }
    } catch (e) {
      _showSnackBar('Authentication failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show a snackbar with the provided message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Show the Forgot Password Modal
  void _showForgotPasswordModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ForgotPasswordModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) => _username = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your username'
                              : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) => _password = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                : Text('Login'),
                          ),
                        ), SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : () {
                              Navigator.pushNamed(context, '/register');
                            },
                            icon: Icon(Icons.app_registration),
                            label: Text('Open an Account'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: _showForgotPasswordModal,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      Icons.fingerprint,
                      color: Colors.blue.shade900,
                      size: 50,
                    ),
                    onPressed: _isLoading ? null : _authenticateBiometric,
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
