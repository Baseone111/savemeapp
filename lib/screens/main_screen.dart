import 'package:flutter/material.dart';
import 'package:trafficking_detector/screens/alert_screen.dart';
import 'package:trafficking_detector/screens/home_screen.dart';
import 'package:trafficking_detector/screens/profileScreen.dart';
import 'package:trafficking_detector/screens/report_screen.dart';
import 'package:trafficking_detector/screens/resources_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isEmergencyMode = false;

  final List<Widget> _screens = [
    HomeScreen(),
    ReportScreen(),
    AlertsScreen(),
    ResourcesScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xffda500c),
          unselectedItemColor: Colors.grey[600],
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Alerts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), label: 'Resources'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmergencyDialog(),
        backgroundColor: Colors.red[600],
        child: Icon(Icons.emergency, color: Colors.white),
        tooltip: 'Emergency',
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Emergency Alert', style: TextStyle(color: Colors.red[700])),
        content:
            Text('Are you in immediate danger? This will alert authorities.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/emergency');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
            child:
                Text('Yes, Send Alert', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
