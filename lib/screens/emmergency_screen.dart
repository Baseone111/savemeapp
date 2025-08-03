import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isEmergencyActive = false;
  Timer? _emergencyTimer;
  int _countdown = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text('Emergency'),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (!_isEmergencyActive) ...[
              _buildEmergencyWarning(),
              SizedBox(height: 30),
              _buildEmergencyButton(),
              SizedBox(height: 30),
              _buildQuickActions(),
            ] else ...[
              _buildActiveEmergency(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyWarning() {
    return Card(
      color: Colors.red[100],
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.warning, size: 48, color: Colors.red[700]),
            SizedBox(height: 16),
            Text(
              'Emergency Alert',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Only use this if you are in immediate danger. This will alert authorities and your emergency contacts.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return Container(
      width: 200,
      height: 200,
      child: ElevatedButton(
        onPressed: () => _startEmergencyAlert(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          shape: CircleBorder(),
          elevation: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emergency, size: 48, color: Colors.white),
            SizedBox(height: 8),
            Text(
              'EMERGENCY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.phone, color: Colors.green[600]),
          title: Text('Call Emergency Services'),
          subtitle: Text('Dial 911 for immediate help'),
          onTap: () => _callEmergencyServices(),
        ),
        ListTile(
          leading: Icon(Icons.message, color: Colors.blue[600]),
          title: Text('Text Emergency Contact'),
          subtitle: Text('Send SMS to trusted contact'),
          onTap: () => _sendEmergencyText(),
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.purple[600]),
          title: Text('Share Location'),
          subtitle: Text('Share your location with contacts'),
          onTap: () => _shareLocation(),
        ),
      ],
    );
  }

  Widget _buildActiveEmergency() {
    return Column(
      children: [
        Text(
          'Emergency Alert Active',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red[800],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Authorities have been notified',
          style: TextStyle(fontSize: 18, color: Colors.red[700]),
        ),
        SizedBox(height: 30),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[600]!),
          strokeWidth: 6,
        ),
        SizedBox(height: 30),
        Text(
          'Help is on the way',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => _cancelEmergency(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text(
            'Cancel Emergency',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _startEmergencyAlert() {
    setState(() {
      _isEmergencyActive = true;
    });

    // Simulate emergency alert
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emergency alert sent to authorities'),
        backgroundColor: Colors.red[600],
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _cancelEmergency() {
    setState(() {
      _isEmergencyActive = false;
    });

    _emergencyTimer?.cancel();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Emergency alert cancelled')),
    );
  }

  void _callEmergencyServices() {
    // Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling emergency services...')),
    );
  }

  void _sendEmergencyText() {
    // Implement SMS functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sending emergency text...')),
    );
  }

  void _shareLocation() {
    // Implement location sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing location...')),
    );
  }

  @override
  void dispose() {
    _emergencyTimer?.cancel();
    super.dispose();
  }
}
