import 'package:flutter/material.dart';
import 'billspayment.dart';

class PayBillsScreen extends StatelessWidget {
  final int userId;
  final Function refreshUserData;
  final Function refreshCardData;

  PayBillsScreen({
    required this.userId,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Bills'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pay Bills Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to BillsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillsPage(
                      userId: userId,
                      refreshUserData: refreshUserData,
                      refreshCardData: refreshCardData,
                    ),
                  ),
                );
              },
              child: Text('Select Bill Category'),
            ),
          ],
        ),
      ),
    );
  }
}

class BillsPage extends StatelessWidget {
  final int userId;
  final Function refreshUserData;
  final Function refreshCardData;

  BillsPage({
    required this.userId,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  // List of bill categories
  final List<Map<String, dynamic>> billCategories = [
    {'title': 'Electric Utilities', 'icon': Icons.lightbulb, 'providers': ['Meralco', 'Ilijan', 'SPPC', 'NPC', 'Visayan Electric', 'Cotabato Light', 'Davao Light', 'Zamboanga EC', 'Luzon Grid', 'Mindanao Power']},
    {'title': 'Water Utilities', 'icon': Icons.water_drop, 'providers': ['Maynilad', 'Manila Water', 'Cebu Water', 'Davao Water', 'Laguna Water', 'Angeles Water', 'Baguio Water', 'Iloilo Water', 'Cagayan Water', 'Zamboanga Water']},
    {'title': 'Telco & Internet', 'icon': Icons.wifi, 'providers': ['Globe', 'Smart', 'PLDT', 'Converge', 'Sky Cable', 'Sun Cellular', 'DITO', 'Cignal', 'Bayan Tele', 'ABS-CBN TV Plus']},
    {'title': 'Government', 'icon': Icons.receipt_long, 'providers': ['BIR', 'SSS', 'Pag-IBIG', 'PhilHealth', 'LTO', 'NBI', 'COMELEC', 'CHED', 'TESDA', 'PAGCOR']},
    {'title': 'Cable TV', 'icon': Icons.tv, 'providers': ['Sky Cable', 'Cignal', 'Dream Satellite', 'GSat', 'ABS-CBN TV Plus', 'Solar Entertainment', 'Fox+', 'Netflix', 'Disney+', 'HBO Go']},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Bills'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: billCategories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProviderListPage(
                      category: billCategories[index]['title'],
                      providers: billCategories[index]['providers'],
                      userId: userId,
                      refreshUserData: refreshUserData,
                      refreshCardData: refreshCardData,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      billCategories[index]['icon'],
                      size: 48.0,
                      color: Colors.red,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      billCategories[index]['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProviderListPage extends StatelessWidget {
  final String category;
  final List<String> providers;
  final int userId;
  final Function refreshUserData;
  final Function refreshCardData;

  ProviderListPage({
    required this.category,
    required this.providers,
    required this.userId,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(providers[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    provider: providers[index],
                    userId: userId,
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
