class Report {
  final String id;
  final String userId;
  final String incidentType;
  final String? description;
  final String? location;
  final bool isAnonymous;
  final String? attachmentUrl;
  final String agencyLevel;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.incidentType,
    this.description,
    this.location,
    this.isAnonymous = false,
    this.attachmentUrl,
    required this.agencyLevel,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      userId: json['user_id'],
      incidentType: json['incident_type'],
      description: json['description'],
      location: json['location'],
      isAnonymous: json['is_anonymous'] ?? false,
      attachmentUrl: json['attachment_url'],
      agencyLevel: json['agency_level'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'incident_type': incidentType,
        'description': description,
        'location': location,
        'is_anonymous': isAnonymous,
        'attachment_url': attachmentUrl,
        'agency_level': agencyLevel,
      };
}
