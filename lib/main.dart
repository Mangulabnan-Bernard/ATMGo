import 'package:atm_go/screens/bills_page.dart';
import 'package:atm_go/screens/billspayment.dart';
import 'package:atm_go/screens/cash_in.dart';
import 'package:atm_go/screens/changepassword.dart';
import 'package:atm_go/screens/dashboard_screen.dart';
import 'package:atm_go/screens/transaction_history.dart';
import 'package:atm_go/screens/transaction_screen.dart';
import 'package:atm_go/screens/transfer.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/card_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Banking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterScreen());
          case '/dashboard':
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(builder: (_) => DashboardScreen(
                userId: args['userId'],
              ));
            }
            throw ArgumentError('DashboardScreen requires a valid user ID');
          case '/card':
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(builder: (_) => CardScreen(
                userId: args['userId'],
                refreshCardData: args['refreshCardData'],
                cardData: {},
              ));
            }
            throw ArgumentError('CardScreen requires a valid user ID and refreshCardData function');
          case '/cash_in':
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => CashInScreen(
                  userId: args['userId'],
                  refreshUserData: args['refreshUserData'],
                  refreshCardData: args['refreshCardData'],
                ),
              );
            }
            throw ArgumentError('CashInScreen requires a valid user ID and refreshUserData function');
          case '/transfer':
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => TransferScreen(
                  userId: args['userId'],
                  selectedBank: '',  // Update this as needed
                  favorite: null,  // Update this as needed
                  recipientAccount: '',  // Update this as needed
                  recipientName: '',  // Update this as needed
                  refreshUserData: args['refreshUserData'],  // Provide a dummy or actual function here
                  refreshCardData: args['refreshCardData'],  // Provide a dummy or actual function here
                ),
              );
            }
            throw ArgumentError('TransferScreen requires a valid user ID');
          case '/pay_bills':
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(builder: (_) => PayBillsScreen(
                userId: args['userId'],
                refreshUserData: args['refreshUserData'],
                refreshCardData: args['refreshCardData'],
              ));
            }
            throw ArgumentError('PayBillsScreen requires a valid user ID, refreshUserData, and refreshCardData');
          case '/settings':
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  user: args['user'], // Pass the UserModel object
                  logout: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  refreshUserData: args['refreshUserData'],
                  refreshCardData: args['refreshCardData'],
                ),
              );
            }
            throw ArgumentError('SettingsScreen requires a valid UserModel object');
          case '/transaction_history':
            if (args is int) {
              return MaterialPageRoute(builder: (_) => TransactionHistoryScreen(userId: args));
            }
            throw ArgumentError('TransactionHistoryScreen requires a valid user ID');
          case '/change_password':
            if (args is int) {
              return MaterialPageRoute(builder: (_) => ChangePasswordScreen(userId: args));
            }
            throw ArgumentError('ChangePasswordScreen requires a valid user ID');
          default:
            return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Route not found'))));
        }
      },
    );
  }
}
