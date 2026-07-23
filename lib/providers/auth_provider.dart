import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  // Cek status login saat app dibuka
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      _user = await _authService.getCurrentUser();
    }
    notifyListeners();
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(
      email: email,
      password: password,
    );

    if (result['success']) {
      _user = result['user'];
      _isLoggedIn = true;
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();

    _user = null;
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }
}