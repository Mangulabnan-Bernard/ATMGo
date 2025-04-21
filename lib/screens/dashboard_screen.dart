import 'package:atm_go/screens/userprofile.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'bills_page.dart';
import 'card_screen.dart';
import 'cash_in.dart';
import 'listbanks.dart';
import 'transaction_history.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;

  DashboardScreen({required this.userId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _userData = {
    'first_name': 'User',
    'balance': 0.0,
    'transactions': [],
  };
  Map<String, dynamic> _cardData = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchCardData();
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await ApiService.getDashboardData(widget.userId);
      setState(() {
        _userData = {
          'user_id': data['user']['user_id'],
          'first_name': data['user']['first_name'],
          'middle_name': data['user']['middle_name'],
          'last_name': data['user']['last_name'],
          'username': data['user']['username'],
          'email': data['user']['email'],
          'mobile_number': data['user']['mobile_number'],
          'birthdate': data['user']['birthdate'],
          'balance': data['card']['balance'] ?? 0.0, // Default to 0.0 if null
          'transactions': data['transactions'] ?? [],
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch dashboard data: $e')),
      );
    }
  }

  Future<void> _fetchCardData() async {
    try {
      final data = await ApiService.getCardData(widget.userId);
      setState(() {
        _cardData = data;
        _userData['balance'] = data['balance'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch card data: $e')),
      );
    }
  }

  Future<void> _logout() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Banking'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildCurrentTab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    user: UserModel.fromMap(_userData),
                    logout: _logout,
                    refreshUserData: _fetchUserData,
                    refreshCardData: _fetchCardData,
                  ),
                ),
              );
            } else {
              _currentIndex = index;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Card'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return HomeTab(
          userData: _userData,
          refreshUserData: _fetchUserData,
          refreshCardData: _fetchCardData,
        );
      case 1:
        return CardScreen(
          cardData: _cardData,
          refreshCardData: _fetchCardData,
          userId: widget.userId,
        );
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}

class HomeTab extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function refreshUserData;
  final Function refreshCardData;

  HomeTab({
    required this.userData,
    required this.refreshUserData,
    required this.refreshCardData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Good Morning, ${userData['first_name']}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  if (userData.containsKey('user_id')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          user: UserModel.fromMap(userData),
                          refreshUserData: refreshUserData,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User ID not found')),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    userData['first_name'] != null
                        ? userData['first_name'][0].toUpperCase()
                        : 'U',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 5),
                  Text(
                    'PHP ${userData['balance']?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (userData.containsKey('user_id')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryScreen(
                          userId: userData['user_id'],
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        refreshUserData();
                        refreshCardData();
                      }
                    });
                  }
                },
                child: Text('View History'),
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildActionTile(
                icon: Icons.attach_money,
                label: 'Cash In',
                onTap: () {
                  if (userData.containsKey('user_id')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashInScreen(
                          userId: userData['user_id'],
                          refreshUserData: refreshUserData,
                          refreshCardData: refreshCardData,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildActionTile(
                icon: Icons.swap_horiz,
                label: 'Transfer',
                onTap: () {
                  if (userData.containsKey('user_id')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BankListScreen(
                          userId: userData['user_id'],
                          refreshUserData: refreshUserData,
                          refreshCardData: refreshCardData,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildActionTile(
                icon: Icons.send,
                label: 'Remittance',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Remittance feature coming soon!')),
                  );
                },
              ),
              _buildActionTile(
                icon: Icons.payment,
                label: 'Pay Bills',
                onTap: () {
                  if (userData.containsKey('user_id')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayBillsScreen(
                          userId: userData['user_id'],
                          refreshUserData: refreshUserData,
                          refreshCardData: refreshCardData,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildActionTile(
                icon: Icons.phone_android,
                label: 'Buy Load',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buy Load feature coming soon!')),
                  );
                },
              ),
              _buildActionTile(
                icon: Icons.more_horiz,
                label: 'More',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('More options not available')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.red),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
