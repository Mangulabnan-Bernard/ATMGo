import 'package:atm_go/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CashInScreen extends StatefulWidget {
  final int userId;
  final Function refreshUserData;
  final Function refreshCardData;

  CashInScreen({
    required this.userId,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  @override
  _CashInScreenState createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  final List<String> _banks = [
    'Bank of Commerce Online',
    'BDO',
    'Metrobank Online',
    'GCash',
    'PayMaya',
    'UnionBank',
    'BPI',
    'LandBank',
    'Security Bank',
    'RCBC',
    'EastWest Bank',
    'PSBank',
    'China Bank',
    'UCPB',
    'Maybank',
    'PNB',
    'DBP',
    'Robinsons Bank',
    'CIMB Bank',
    'ING Bank',
  ];

  String? _selectedBank;
  double _amount = 0.0;
  bool _isLoading = false;
  CardModel? _cardModel;

  @override
  void initState() {
    super.initState();
    _fetchCardData();
  }

  Future<void> _fetchCardData() async {
    try {
      final data = await ApiService.getCardData(widget.userId);
      setState(() {
        _cardModel = CardModel.fromJson(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch card data: $e')),
      );
    }
  }

  Future<void> _cashIn() async {
    if (_selectedBank == null || _amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a bank and enter a valid amount')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Cash In'),
        content: Text('Are you sure you want to cash in from $_selectedBank?\nAmount: ₱${_amount.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.cashIn(widget.userId, _amount);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing...'), duration: Duration(seconds: 8)),
      );

      await Future.delayed(Duration(seconds: 8));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cash in successful')),
      );

      await widget.refreshUserData();
      await widget.refreshCardData();
      await _fetchCardData();

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cash in failed: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cardModel != null)
              Text('Current Balance: ₱${_cardModel!.balance.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Text(
              'Select Bank',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              onChanged: (value) {
                setState(() {
                  _selectedBank = value;
                });
              },
              items: _banks.map((bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select a bank',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _cashIn,
              child: Text('Cash In'),
            ),
          ],
        ),
      ),
    );
  }
}
