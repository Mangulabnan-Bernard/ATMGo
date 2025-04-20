import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '', _password = '';
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  String _biometricStatus = 'Checking...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();

      bool canCheckBiometrics = await auth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      print('Can check biometrics: $canCheckBiometrics');
      print('Available biometrics: $availableBiometrics');

      setState(() {
        _isBiometricAvailable = canCheckBiometrics && availableBiometrics.isNotEmpty;
        _biometricStatus = _isBiometricAvailable
            ? 'Biometric available: $availableBiometrics'
            : 'Biometric not available';
      });
    } catch (e) {
      setState(() {
        _biometricStatus = 'Error checking biometrics: $e';
      });
    }
  }




  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        await _navigateToDashboard();
      }
    } catch (e) {
      _showSnackBar('Biometric authentication failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _navigateToDashboard();
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToDashboard() async {
    final response = await ApiService.login(_username, _password);
    if (response['message'] == 'Login successful') {
      final userId = response['user_id'];
      final mobileNumber = response['mobile_number'] ?? '';

      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
        arguments: {
          'userId': userId,
          'mobileNumber': mobileNumber,
        },
      );
    } else {
      _showSnackBar('Invalid credentials');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _biometricStatus,
                      style: TextStyle(color: Colors.red),
                    ),
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
                          ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text('Login'),
                          ),
                          if (_isBiometricAvailable) ...[
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed:
                              _isLoading ? null : _authenticateWithBiometrics,
                              icon: Icon(Icons.fingerprint),
                              label: Text('Login with Fingerprint'),
                            ),
                          ],
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: Text(
                              'Open an account',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}