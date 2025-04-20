import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/api_service.dart';
import 'register_screen.dart'; // Ensure the correct import for RegisterScreen
import 'dashboard_screen.dart'; // Ensure the correct import for DashboardScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Bank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Welcome to our digital bank',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
  }

  // Authenticate with PIN or Fingerprint
  Future<void> _authenticate() async {
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
        _showSnackBar('Process successful');
        // Navigate to the dashboard or perform any other action
        if (_userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userId: _userId!),
            ),
          );
        } else {
          _showSnackBar('User ID not available');
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
        print('User ID received: $_userId'); // Debug print
        await _authenticate(); // Trigger PIN or Fingerprint authentication
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

  // Show a snackbar with the provided message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
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
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
                          onChanged: (value) => _password = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: Icon(Icons.app_registration),
                      label: Text('Open an Account'),
                    ),
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
