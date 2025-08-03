// models/missing_person.dart
import 'package:uuid/uuid.dart';

class MissingPerson {
  final String id;
  final String name;
  final String age;
  final String description;
  final String lastSeenLocation;
  final String? last_seen; // Nullable if not always provided
  final String relationship;
  final String? photoUrl; // URL of the uploaded photo
  final String? user_id; // To link to a Supabase user if logged in
  final DateTime reportedAt;

  MissingPerson({
    String? id,
    required this.name,
    required this.age,
    required this.description,
    required this.lastSeenLocation,
    this.last_seen,
    required this.relationship,
    this.photoUrl,
    this.user_id,
    DateTime? reportedAt,
  })  : this.id = id ?? Uuid().v4(),
        this.reportedAt = reportedAt ?? DateTime.now().toUtc(); // Store in UTC

  // Convert to JSON for Supabase insertion
  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'name': name,
      'age': age != null && age!.isNotEmpty ? int.tryParse(age!) : null,
      'description': description,
      'last_seen_location': lastSeenLocation,
      'last_seen': last_seen, // Supabase can handle String or DateTime
      'relationship': relationship,
      'photo_url': photoUrl,
      'user_id': user_id,
      'reported_at': reportedAt.toIso8601String(),
    };
  }

  // Optionally, a factory constructor to create from Supabase data
  factory MissingPerson.fromJson(Map<String, dynamic> json) {
    return MissingPerson(
      id: json['id']?.toString(),
      name: json['name'],
      age: json['age'].toString(),
      description: json['description'],
      lastSeenLocation: json['last_seen_location'],
      last_seen: json['last_seen'],
      relationship: json['relationship'],
      photoUrl: json['photo_url'],
      user_id: json['user_id'],
      reportedAt: DateTime.parse(json['reported_at']),
    );
  }
}
