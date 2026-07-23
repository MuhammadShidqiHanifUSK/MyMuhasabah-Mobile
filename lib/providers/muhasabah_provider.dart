import 'package:flutter/material.dart';
import '../models/muhasabah_model.dart';
import '../services/api_service.dart';

class MuhasabahProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<MuhasabahModel> _muhasabahs = [];
  MuhasabahModel? _selectedMuhasabah;
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  List<MuhasabahModel> get muhasabahs => _muhasabahs;
  MuhasabahModel? get selectedMuhasabah => _selectedMuhasabah;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  // Ambil semua catatan
  Future<void> fetchMuhasabahs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _muhasabahs = [];
      _hasMoreData = true;
    }

    if (!_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    final result = await _apiService.getMuhasabahs(page: _currentPage);

    if (result['success']) {
      final data = result['data'];
      final List items = data['data'];
      final newItems = items.map((e) => MuhasabahModel.fromJson(e)).toList();

      _muhasabahs.addAll(newItems);
      _currentPage++;
      _hasMoreData = data['next_page_url'] != null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Ambil detail catatan
  Future<void> fetchMuhasabah(int id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.getMuhasabah(id);

    if (result['success']) {
      _selectedMuhasabah = MuhasabahModel.fromJson(result['data']);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Buat catatan baru
  Future<Map<String, dynamic>> createMuhasabah(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.createMuhasabah(data);

    if (result['success']) {
      await fetchMuhasabahs(refresh: true);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Update catatan
  Future<Map<String, dynamic>> updateMuhasabah(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.updateMuhasabah(id, data);

    if (result['success']) {
      await fetchMuhasabahs(refresh: true);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Hapus catatan
  Future<Map<String, dynamic>> deleteMuhasabah(int id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.deleteMuhasabah(id);

    if (result['success']) {
      _muhasabahs.removeWhere((m) => m.id == id);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}