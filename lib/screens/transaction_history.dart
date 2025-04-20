import 'package:atm_go/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final int userId;
  TransactionHistoryScreen({required this.userId});

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await ApiService.getTransactionHistory(widget.userId);
      setState(() {
        _transactions = (response as List).map((json) => TransactionModel.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch transactions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction History')),
      body: _transactions.isEmpty
          ? Center(child: Text('No transactions yet'))
          : ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return ListTile(
            title: Text(transaction.description),
            subtitle: Text('${transaction.type} - ₱${transaction.amount}'),
            trailing: Text(transaction.createdAt),
          );
        },
      ),
    );
  }
}
