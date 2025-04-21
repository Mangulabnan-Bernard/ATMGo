import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/api_service.dart';

class CardScreen extends StatefulWidget {
  final int userId;
  final Function refreshCardData;

  CardScreen({
    required this.userId,
    required this.refreshCardData, required Map<String, dynamic> cardData,
  });

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  CardModel? _cardModel; // Remove 'late' and allow null

  @override
  void initState() {
    super.initState();
    _fetchCardData(); // Fetch data when the widget initializes
  }

  @override
  void didUpdateWidget(covariant CardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _fetchCardData(); // Refetch data if the user ID changes
    }
  }

  Future<void> _fetchCardData() async {
    try {
      print('Fetching card data for user ID: ${widget.userId}');
      final data = await ApiService.getCardData(widget.userId);
      print('Card Data Response: $data');

      if (data.containsKey('message')) {
        setState(() {
          _cardModel = null; // Set to null if no data is available
        });
        return;
      }

      setState(() {
        _cardModel = CardModel.fromJson(data); // Update with fetched data
      });
    } catch (e) {
      print('Error fetching card data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch card data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while data is being fetched
    if (_cardModel == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Card Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(), // Loading spinner
              SizedBox(height: 16),
              Text('Loading card details...'), // Optional loading message
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ATMGO'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(56.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image Section
            Container(
              width: double.infinity,
              height: 390,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        'assets/images/atmcard.png',
                      ),
                    ),
                  ),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(  65,70,4,4), // move a bit to the left
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_cardModel!.firstName} ${_cardModel!.lastName}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${_cardModel!.cardNumber}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_cardModel!.expiryDate}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 80),
                            Text(
                              'CVV: ${_cardModel!.cvv.substring(_cardModel!.cvv.length - 3)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            // Options Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              ],
            ),
            SizedBox(height: 20),

            // Card Status Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
