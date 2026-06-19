import '../../domain/models/user.dart';
import '../services/auth_service.dart';
import '../services/token_storage_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthService authService,
    required TokenStorageService tokenStorageService,
  }) : _authService = authService,
       _tokenStorageService = tokenStorageService;

  final AuthService _authService;
  final TokenStorageService _tokenStorageService;

  Future<User> login({required String email, required String password}) async {
    final result = await _authService.login(email: email, password: password);
    await _tokenStorageService.saveToken(
      accessToken: result.accessToken,
      tokenType: result.tokenType,
    );
    return result.user;
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
    );
    await _tokenStorageService.saveToken(
      accessToken: result.accessToken,
      tokenType: result.tokenType,
    );
    return result.user;
  }

  Future<void> logout() async {
    final token = await _tokenStorageService.readAccessToken();
    if (token != null && token.isNotEmpty) {
      await _authService.logout(token);
    }
    await _tokenStorageService.clear();
  }

  Future<String?> getAccessToken() => _tokenStorageService.readAccessToken();
}
