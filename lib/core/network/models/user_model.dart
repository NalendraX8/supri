import 'dart:convert';

/// User model for API responses.
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
