import 'package:trafficking_detector/core/commons/entities/user.dart';

class UserModel extends User {
  final String phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required String id,
    required String email,
    required String name, // Combine firstName + lastName before passing here
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          email: email,
          name: name,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] ?? '';
    final lastName = json['last_name'] ?? '';
    final name = '$firstName $lastName';

    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      name: name,
      phoneNumber: json['phone_number'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final json = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
    };

    if (id.isNotEmpty) {
      json['id'] = id;
    }
    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }
    if (updatedAt != null) {
      json['updated_at'] = updatedAt!.toIso8601String();
    }

    return json;
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
