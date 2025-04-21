import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:atm_go/screens/transaction_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};
  TextEditingController _birthdateController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await ApiService.register(_formData);
      if (response['message'] == 'User registered successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
        int userId = int.parse(response['user_id'].toString());
        final cardResponse = await ApiService.getCardData(userId);
        Navigator.pushReplacementNamed(context, '/login');
      } else if (response['message'] == 'Email already exists') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: Email already exists')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _birthdateController.text = formattedDate;
        _formData['birthdate'] = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onChanged: (value) => _formData['first_name'] = value,
                validator: (value) => value!.isEmpty ? 'Enter first name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => _formData['last_name'] = value,
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) => _formData['username'] = value,
                validator: (value) => value!.isEmpty ? 'Enter username' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => _formData['password'] = value,
                validator: (value) => value!.isEmpty ? 'Enter password' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => _formData['mobile_number'] = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter mobile number';
                  } else if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                    return 'Enter a valid 11-digit number starting with 09';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _formData['email'] = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter email';
                  } else if (!value.endsWith('@gmail.com')) {
                    return 'Only Gmail addresses allowed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: 'Birthdate (YYYY-MM-DD)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Pick your birthdate' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
