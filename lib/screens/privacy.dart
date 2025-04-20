import 'package:flutter/material.dart';
import 'aboutatmgo.dart';
import 'privacy.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Effective Date: Aprin 20,2025\n\n',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'Introduction\n\n'
                  'At ATMGo, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app. By using ATMGo, you consent to the practices outlined in this policy.\n\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '1. Information We Collect\n\n',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'We collect the following types of information:\n\n'
                  '- Personal Information: This may include your name, email address, phone number, and payment details.\n'
                  '- Device Information: We may collect information about the device you use to access ATMGo, including your device model, operating system, and app version.\n'
                  '- Usage Data: We collect data on how you interact with the app, including login activity, transaction history, and app settings.\n\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '2. How We Use Your Information\n\n',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'We use your personal information to:\n\n'
                  '- Provide and manage our services, including processing transactions.\n'
                  '- Improve the app’s functionality and user experience.\n'
                  '- Communicate with you about updates, offers, or issues related to the app.\n'
                  '- Ensure the security and integrity of your data.\n\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '3. Data Security\n\n',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'We implement various security measures to protect your personal information, including encryption during transactions and secure authentication. However, no system is entirely secure, and we cannot guarantee complete security.\n\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '4. Sharing Your Information\n\n',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'We do not sell or rent your personal information to third parties. However, we may share your information with:\n\n'
                  '- Service Providers: We may share your data with trusted third-party service providers who help us run the app (e.g., payment processors, cloud hosting providers).\n'
                  '- Legal Requirements: If required by law, we may disclose your information to comply with legal obligations or protect our rights.\n\n',
              style: TextStyle(fontSize: 16),
            ),



          ],
        ),
      ),
    );
  }
}
