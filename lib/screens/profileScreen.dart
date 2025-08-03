import 'package:flutter/material.dart';
import 'package:trafficking_detector/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
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

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.gavel,
                    title: 'Active Complaints',
                    value: '590',
                    color: Colors.pink,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    title: 'Solve Complaints',
                    value: '2,300',
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    title: 'Show Complaints',
                    value: '2,700',
                    color: Colors.pink,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today,
                    title: 'Schedules',
                    value: '7',
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Menu Items
            _buildMenuItem(
              icon: Icons.search,
              title: 'Find Lawyer',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.report,
              title: 'My Complaint',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.star,
              title: 'Review',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.message,
              title: 'Message',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.support,
              title: 'Support Ticket',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.description,
              title: 'Terms & Condition',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: 'App Info',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
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

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
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
