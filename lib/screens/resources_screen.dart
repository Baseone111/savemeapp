import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Resources'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyContacts(),
            SizedBox(height: 20),
            _buildSafetyGuides(),
            SizedBox(height: 20),
            _buildHelplineNumbers(),
            SizedBox(height: 20),
            _buildEducationalContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contacts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildContactCard(
            'Emergency Services', '911', Icons.local_hospital, Colors.red),
        _buildContactCard('National Human Trafficking Hotline',
            '1-888-373-7888', Icons.phone, Colors.blue),
        _buildContactCard('Crisis Text Line', 'Text HOME to 741741',
            Icons.message, Colors.green),
      ],
    );
  }

  Widget _buildContactCard(
      String title, String contact, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(contact),
        trailing: IconButton(
          icon: Icon(Icons.call),
          onPressed: () {
            // Implement calling functionality
          },
        ),
      ),
    );
  }

  Widget _buildSafetyGuides() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Guides',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildGuideCard('Recognizing Trafficking Signs',
            'Learn the warning signs of human trafficking', Icons.visibility),
        _buildGuideCard('Personal Safety Tips',
            'Stay safe in various situations', Icons.security),
        _buildGuideCard('Reporting Guidelines',
            'How to report incidents safely', Icons.report),
        _buildGuideCard('Supporting Survivors',
            'How to help trafficking survivors', Icons.favorite),
      ],
    );
  }

  Widget _buildGuideCard(String title, String description, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[600]),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to guide details
        },
      ),
    );
  }

  Widget _buildHelplineNumbers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support Helplines',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildHelplineCard(
            'Childhelp National Child Abuse Hotline', '1-800-422-4453'),
        _buildHelplineCard(
            'National Domestic Violence Hotline', '1-800-799-7233'),
        _buildHelplineCard('National Sexual Assault Hotline', '1-800-656-4673'),
      ],
    );
  }

  Widget _buildHelplineCard(String name, String number) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.support_agent, color: Colors.purple[600]),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(number),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Educational Content',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildEducationCard(
          'Understanding Human Trafficking',
          'Learn about different types of trafficking and how to identify them.',
          Icons.school,
        ),
        _buildEducationCard(
          'Prevention Strategies',
          'Discover ways to protect yourself and your community.',
          Icons.shield,
        ),
        _buildEducationCard(
          'Legal Rights & Resources',
          'Know your rights and available legal assistance.',
          Icons.gavel,
        ),
      ],
    );
  }

  Widget _buildEducationCard(String title, String description, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[600]),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: Icon(Icons.play_circle_outline),
        onTap: () {
          // Navigate to educational content
        },
      ),
    );
  }
}
