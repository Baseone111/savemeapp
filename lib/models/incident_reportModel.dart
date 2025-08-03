// packages/trafficking_detector/models/incident_reportModel.dart (Verify or create this)

import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  final String incidentType;
  final String description;
  final String location;
  final bool anonymous;
  final DateTime reportedAt;
  final String? userId; // Nullable for anonymous reports
  final String urgencyLevel; // Add this field

  const ReportModel({
    required this.incidentType,
    required this.description,
    required this.location,
    required this.anonymous,
    required this.reportedAt,
    this.userId,
    required this.urgencyLevel, // Make it required
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      incidentType: json['incident_type'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      anonymous: json['anonymous'] as bool,
      reportedAt: DateTime.parse(json['reported_at'] as String),
      userId: json['user_id'] as String?,
      urgencyLevel: json['urgency_level'] as String, // Parse this field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incident_type': incidentType,
      'description': description,
      'location': location,
      'anonymous': anonymous,
      'reported_at': reportedAt.toIso8601String(),
      'user_id': userId,
      'urgency_level': urgencyLevel, // Include in toJson
    };
  }

  @override
  List<Object?> get props => [
        incidentType,
        description,
        location,
        anonymous,
        reportedAt,
        userId,
        urgencyLevel,
      ];
}
