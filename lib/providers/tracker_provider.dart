import 'package:flutter/material.dart';
import '../models/tracker_model.dart';
import '../services/api_service.dart';

class TrackerProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TrackerModel> _trackers = [];
  TrackerModel? _selectedTracker;
  bool _isLoading = false;
  String? _currentBulan;

  List<TrackerModel> get trackers => _trackers;
  TrackerModel? get selectedTracker => _selectedTracker;
  bool get isLoading => _isLoading;

  // Ambil tracker per bulan
  Future<void> fetchTrackers({String? bulan}) async {
    _isLoading = true;
    _currentBulan = bulan;
    notifyListeners();

    final result = await _apiService.getTrackers(bulan: bulan);

    if (result['success']) {
      final List items = result['data']['trackers'];
      _trackers = items.map((e) => TrackerModel.fromJson(e)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Ambil tracker per tanggal
  Future<void> fetchTracker(String tanggal) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.getTracker(tanggal);

    if (result['success'] && result['data']['tracker'] != null) {
      _selectedTracker = TrackerModel.fromJson(result['data']['tracker']);
    } else {
      _selectedTracker = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Simpan tracker
  Future<Map<String, dynamic>> saveTracker(
      String tanggal, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.saveTracker(tanggal, data);

    if (result['success']) {
      await fetchTrackers(bulan: _currentBulan);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Cek apakah tanggal sudah diisi
  bool isTanggalTerisi(String tanggal) {
    return _trackers.any((t) => t.tanggal == tanggal);
  }
}