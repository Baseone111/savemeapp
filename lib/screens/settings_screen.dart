import 'package:flutter/material.dart';
import 'package:trafficking_detector/screens/profilesettingsScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.pink[100],
                    child:
                        Icon(Icons.person, size: 40, color: Colors.pink[300]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cody Lee',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'codylee@gmail.com',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.verified, color: Colors.green, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Settings Menu Items
            _buildSettingsItem(
              icon: Icons.person,
              title: 'Profile Setting',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileSettingsScreen()),
                );
              },
            ),
            _buildSettingsItem(
              icon: Icons.notifications,
              title: 'Notifications Setting',
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.language,
              title: 'Language',
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.link,
              title: 'Link Account',
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.lock,
              title: 'Password Change',
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.delete,
              title: 'Delete Account',
              onTap: () {},
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 4,
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.pink,
      //   unselectedItemColor: Colors.grey,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.report), label: 'Complaints'),
      //     BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
      //     BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[600]),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
