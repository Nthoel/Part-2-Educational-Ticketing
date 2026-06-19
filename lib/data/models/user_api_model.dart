import '../../domain/models/user.dart';

class UserApiModel {
  const UserApiModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
