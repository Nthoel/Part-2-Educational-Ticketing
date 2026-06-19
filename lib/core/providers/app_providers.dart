import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/profile_service.dart';
import '../../data/services/token_storage_service.dart';
import '../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../features/profile/presentation/view_models/profile_view_model.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.read(authServiceProvider),
    tokenStorageService: ref.read(tokenStorageServiceProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    profileService: ref.read(profileServiceProvider),
    tokenStorageService: ref.read(tokenStorageServiceProvider),
  );
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

final profileViewModelProvider = ChangeNotifierProvider<ProfileViewModel>((
  ref,
) {
  return ProfileViewModel(ref.read(profileRepositoryProvider));
});
