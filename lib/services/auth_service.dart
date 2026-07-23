import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Simpan token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Ambil token
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Hapus token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  // Cek apakah sudah login
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return {'success': true, 'message': response.data['message']};
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Terjadi kesalahan.';
      return {'success': false, 'message': message};
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['token'];
      final user = UserModel.fromJson(response.data['user']);

      await saveToken(token);

      return {'success': true, 'user': user};
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Terjadi kesalahan.';
      final emailVerified = e.response?.data['email_verified'] ?? true;
      return {
        'success': false,
        'message': message,
        'email_verified': emailVerified,
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final token = await getToken();
      await _dio.post(
        ApiConfig.logout,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (_) {}
    await deleteToken();
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        ApiConfig.user,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }
}