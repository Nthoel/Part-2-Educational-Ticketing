import '../../domain/models/user.dart';
import 'user_api_model.dart';

class AuthResultApiModel {
  const AuthResultApiModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final User user;

  factory AuthResultApiModel.fromJson(Map<String, dynamic> json) {
    final userJson =
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return AuthResultApiModel(
      accessToken: json['access_token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 0,
      user: UserApiModel.fromJson(userJson).toDomain(),
    );
  }
}
