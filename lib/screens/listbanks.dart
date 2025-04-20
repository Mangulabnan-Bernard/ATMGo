import 'package:atm_go/screens/transfer.dart';
import 'package:flutter/material.dart';

class BankListScreen extends StatelessWidget {
  final int userId;
  final Function refreshUserData;
  final Function refreshCardData;

  BankListScreen({
    required this.userId,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  @override
  Widget build(BuildContext context) {
    // List of 30 Philippine Banks
    List<String> banks = [
      'BPI (Bank of the Philippine Islands)',
      'BDO (Banco de Oro)',
      'Metrobank',
      'Land Bank of the Philippines',
      'Philippine National Bank (PNB)',
      'UnionBank of the Philippines',
      'Security Bank',
      'EastWest Bank',
      'RCBC (Rizal Commercial Banking Corporation)',
      'China Bank (China Banking Corporation)',
      'UCPB (United Coconut Planters Bank)',
      'Bank of Commerce',
      'DBP (Development Bank of the Philippines)',
      'Maybank Philippines',
      'PSBank (Philippine Savings Bank)',
      'CTBC Bank Philippines',
      'Standard Chartered Bank',
      'Citibank Philippines',
      'HSBC Philippines',
      'Bank of the Philippine Islands (BPI)',
      'First Metro Investment Corporation',
      'Philippine Business Bank',
      'Citi Philippines',
      'AUB (Asia United Bank)',
      'Sun Life Financial',
      'Pinehill Philippines',
      'BPI Family Savings Bank',
      'ING Philippines',
      'BancNet',
      'Security Bank Corporation',
      'Sterling Bank of Asia'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bank for Transfer'),
      ),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return ListTile(
            title: Text(bank),
            onTap: () {
              // Navigate to the transfer screen with selected bank details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransferScreen(
                    userId: userId,
                    selectedBank: bank,
                    recipientAccount: '', // Account number will be entered manually
                    recipientName: '', // You can pass the recipient name if needed
                    favorite: null, // Modify based on your favorite logic
                    refreshUserData: refreshUserData,
                    refreshCardData: refreshCardData,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
