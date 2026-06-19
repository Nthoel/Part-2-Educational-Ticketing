import 'package:flutter/foundation.dart';

import '../../../../data/repositories/profile_repository.dart';
import '../../../../domain/models/user.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._profileRepository);

  final ProfileRepository _profileRepository;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> loadProfile() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _profileRepository.getMe();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateName(String name) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _profileRepository.updateMe(name);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
