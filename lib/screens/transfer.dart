import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class TransferScreen extends StatefulWidget {
  final int userId;
  final String selectedBank;
  final String recipientAccount;
  final String recipientName;
  final dynamic favorite;
  final Function refreshUserData;
  final Function refreshCardData;

  TransferScreen({
    required this.userId,
    required this.selectedBank,
    required this.recipientAccount,
    required this.recipientName,
    this.favorite,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _recipientAccount;
  String? _recipientName;
  double _amount = 0.0;
  bool _isLoading = false;
  bool _setAsFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.favorite != null) {
      _recipientAccount = widget.favorite['account_number'];
      _recipientName = widget.favorite['account_name'];
    } else {
      _recipientAccount = widget.recipientAccount;
      _recipientName = widget.recipientName;
    }
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Future<void> _transferFunds() async {
    if (_formKey.currentState!.validate()) {
      if (_recipientAccount == null ||
          _recipientAccount!.isEmpty ||
          _recipientName == null ||
          _recipientName!.isEmpty ||
          _amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all the required fields.')),
        );
        return;
      }

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Transfer'),
          content: Text(
            'Are you sure you want to transfer ₱${_amount.toStringAsFixed(2)} to $_recipientName at ${widget.selectedBank}?',
          ),
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
        final response = await ApiService.transferFunds(
          widget.userId,
          _recipientAccount!,
          _amount,
          widget.selectedBank,
        );

        if (response['status'] == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transfer failed: ${response['message']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transfer successful')),
          );

          if (_setAsFavorite) {
            await ApiService.addFavorite(
              widget.userId,
              widget.selectedBank,
              _recipientName!,
              _recipientAccount!,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Recipient added to favorites')),
            );
          }

          await widget.refreshUserData();
          await widget.refreshCardData();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen(
                    userId: widget.userId,),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Funds'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recipient Bank',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.selectedBank,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildTextField(
                label: 'Recipient Account Number',
                initialValue: _recipientAccount,
                onChanged: (value) => _recipientAccount = value,
                validator: (value) => value!.isEmpty
                    ? 'Please enter recipient account number'
                    : null,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: 'Recipient\'s Account Name',
                initialValue: _recipientName,
                onChanged: (value) => _recipientName = value,
                validator: (value) =>
                value!.isEmpty ? 'Please enter recipient name' : null,
              ),
              _buildTextField(
                label: 'Amount',
                initialValue: _amount > 0 ? _amount.toString() : '',
                onChanged: (value) =>
                _amount = double.tryParse(value) ?? 0.0,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter amount';
                  if (double.tryParse(value)! <= 0)
                    return 'Amount must be greater than 0';
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: Text("Set as Favorite"),
                value: _setAsFavorite,
                onChanged: (value) {
                  setState(() {
                    _setAsFavorite = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _transferFunds,
                child: Text('Transfer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
