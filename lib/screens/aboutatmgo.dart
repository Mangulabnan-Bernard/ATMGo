import 'package:flutter/material.dart';

class AboutATMGoScreen extends StatefulWidget {
  @override
  _AboutATMGoScreenState createState() => _AboutATMGoScreenState();
}

class _AboutATMGoScreenState extends State<AboutATMGoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About ATMGo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About ATMGo\n',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'ATMGo is an innovative financial mobile application that aims to provide users with a seamless and secure way to manage their banking transactions. With ATMGo, users can access various ATM services, track transaction history, and much more—all from the palm of their hands.\n\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Our mission is to simplify financial management and provide users with easy access to banking services while ensuring their data is secure and protected.\n\n',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
