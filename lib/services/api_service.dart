import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  Future<Dio> _getDio() async {
    final token = await _storage.read(key: 'token');
    return Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
  }

  // ── Dashboard ──
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final dio = await _getDio();
      final response = await dio.get(ApiConfig.dashboard);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  // ── Muhasabah ──
  Future<Map<String, dynamic>> getMuhasabahs({int page = 1}) async {
    try {
      final dio = await _getDio();
      final response = await dio.get('${ApiConfig.muhasabah}?page=$page');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  Future<Map<String, dynamic>> getMuhasabah(int id) async {
    try {
      final dio = await _getDio();
      final response = await dio.get('${ApiConfig.muhasabah}/$id');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  Future<Map<String, dynamic>> createMuhasabah(Map<String, dynamic> data) async {
    try {
      final dio = await _getDio();
      final response = await dio.post(ApiConfig.muhasabah, data: data);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  Future<Map<String, dynamic>> updateMuhasabah(int id, Map<String, dynamic> data) async {
    try {
      final dio = await _getDio();
      final response = await dio.put('${ApiConfig.muhasabah}/$id', data: data);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  Future<Map<String, dynamic>> deleteMuhasabah(int id) async {
    try {
      final dio = await _getDio();
      final response = await dio.delete('${ApiConfig.muhasabah}/$id');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  // ── Tracker ──
  Future<Map<String, dynamic>> getTrackers({String? bulan}) async {
    try {
      final dio = await _getDio();
      final url = bulan != null
          ? '${ApiConfig.tracker}?bulan=$bulan'
          : ApiConfig.tracker;
      final response = await dio.get(url);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  Future<Map<String, dynamic>> getTracker(String tanggal) async {
    try {
      final dio = await _getDio();
      final response = await dio.get('${ApiConfig.tracker}/$tanggal');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }

  Future<Map<String, dynamic>> saveTracker(String tanggal, Map<String, dynamic> data) async {
    try {
      final dio = await _getDio();
      final response = await dio.post('${ApiConfig.tracker}/$tanggal', data: data);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Terjadi kesalahan.'};
    }
  }
}