import '../../domain/models/user.dart';
import '../services/profile_service.dart';
import '../services/token_storage_service.dart';

class ProfileRepository {
  ProfileRepository({
    required ProfileService profileService,
    required TokenStorageService tokenStorageService,
  }) : _profileService = profileService,
       _tokenStorageService = tokenStorageService;

  final ProfileService _profileService;
  final TokenStorageService _tokenStorageService;

  Future<User> getMe() async {
    final token = await _tokenStorageService.readAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized: token tidak ditemukan');
    }

    final userModel = await _profileService.getMe(token);
    return userModel.toDomain();
  }

  Future<User> updateMe(String name) async {
    final token = await _tokenStorageService.readAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized: token tidak ditemukan');
    }

    final userModel = await _profileService.updateMe(
      accessToken: token,
      name: name,
    );
    return userModel.toDomain();
  }
}
