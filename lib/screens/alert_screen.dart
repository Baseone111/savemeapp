import 'package:flutter/material.dart';
import 'package:trafficking_detector/models/alert_models.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<AlertItem> _alerts = [
    AlertItem(
      title: 'High Risk Area Alert',
      description:
          'Increased suspicious activity reported in Downtown area. Exercise caution.',
      time: '2 hours ago',
      type: AlertType.warning,
      isRead: false,
    ),
    AlertItem(
      title: 'Missing Person Update',
      description:
          'Sarah Johnson case - New information received. Last seen near Central Park.',
      time: '5 hours ago',
      type: AlertType.info,
      isRead: true,
    ),
    AlertItem(
      title: 'Community Safety Reminder',
      description:
          'Remember to report any suspicious activities. Your vigilance helps keep everyone safe.',
      time: '1 day ago',
      type: AlertType.general,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts & Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showNotificationSettings(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAlertFilters(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _alerts.length,
              itemBuilder: (context, index) => _buildAlertCard(_alerts[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: FilterChip(
              label: Text('All'),
              selected: true,
              onSelected: (selected) {},
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: FilterChip(
              label: Text('Urgent'),
              selected: false,
              onSelected: (selected) {},
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: FilterChip(
              label: Text('Updates'),
              selected: false,
              onSelected: (selected) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(AlertItem alert) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: alert.isRead ? 1 : 3,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getAlertColor(alert.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getAlertIcon(alert.type),
            color: _getAlertColor(alert.type),
          ),
        ),
        title: Text(
          alert.title,
          style: TextStyle(
            fontWeight: alert.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(alert.description),
            SizedBox(height: 4),
            Text(
              alert.time,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: !alert.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () => _markAsRead(alert),
      ),
    );
  }

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return Colors.orange[600]!;
      case AlertType.info:
        return Colors.blue[600]!;
      case AlertType.general:
        return Colors.green[600]!;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return Icons.warning;
      case AlertType.info:
        return Icons.info;
      case AlertType.general:
        return Icons.notifications;
    }
  }

  void _markAsRead(AlertItem alert) {
    setState(() {
      alert.isRead = true;
    });
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notification Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Emergency Alerts'),
              subtitle: Text('Critical safety alerts'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Missing Person Updates'),
              subtitle: Text('Updates on missing person cases'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Community Alerts'),
              subtitle: Text('General community safety information'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
