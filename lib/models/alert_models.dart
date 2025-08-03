// lib/models/alert.dart

import 'package:flutter/material.dart'; // Import for IconData if you decide to include it here

enum AlertType {
  warning,
  info,
  general,
}

class AlertItem {
  final String title;
  final String description;
  final String time;
  final AlertType type;
  bool isRead; // This can be changed as the state changes

  AlertItem({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false, // Default to false
  });
}
