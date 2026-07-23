import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../muhasabah/muhasabah_list_screen.dart';
import '../tracker/tracker_calendar_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() => _isLoading = true);
    final result = await _apiService.getDashboard();
    if (result['success']) {
      setState(() {
        _dashboardData = result['data'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<AuthProvider>().logout();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final screens = [
      _buildDashboardBody(auth),
      const MuhasabahListScreen(),
      const TrackerCalendarScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text('🌙 ', style: const TextStyle(fontSize: 20)),
            Text(
              'MyMuhasabah',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF047857),
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6B7280)),
            onPressed: _logout,
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFF059669),
        unselectedItemColor: const Color(0xFF6B7280),
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), activeIcon: Icon(Icons.book), label: 'Muhasabah'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), activeIcon: Icon(Icons.check_circle), label: 'Tracker'),
        ],
      ),
    );
  }

  Widget _buildDashboardBody(AuthProvider auth) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF059669)));
    }

    return RefreshIndicator(
      color: const Color(0xFF059669),
      onRefresh: _fetchDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sambutan
            _buildSambutan(auth),
            const SizedBox(height: 16),

            // Streak
            if ((_dashboardData?['streak'] ?? 0) > 0) ...[
              _buildStreakCard(),
              const SizedBox(height: 16),
            ],

            // Stat Cards
            _buildStatCards(),
            const SizedBox(height: 16),

            // Tracker Hari Ini
            _buildTrackerHariIni(),
            const SizedBox(height: 16),

            // Catatan Terbaru
            _buildCatatanTerbaru(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSambutan(AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF059669),
            child: Text(
              auth.user?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assalamu\'alaikum,',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280)),
                ),
                Text(
                  auth.user?.name ?? 'User',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('d MMM', 'id').format(DateTime.now()),
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    final streak = _dashboardData?['streak'] ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$streak Hari Streak!', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Pertahankan konsistensimu! 💪', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    final data = _dashboardData;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: [
        _statCard('📔', 'Total Catatan', '${data?['total_catatan'] ?? 0}', const Color(0xFF059669)),
        _statCard('📅', 'Bulan Ini', '${data?['catatan_bulan_ini'] ?? 0}', const Color(0xFF3B82F6)),
        _statCard('🕌', 'Sholat Minggu Ini', '${data?['persen_sholat'] ?? 0}%', const Color(0xFFF59E0B)),
        _statCard('📖', 'Tilawah Minggu Ini', '${data?['total_tilawah'] ?? 0} hal', const Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _statCard(String emoji, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerHariIni() {
    final tracker = _dashboardData?['tracker_hari_ini'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('✅ Tracker Hari Ini', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 2),
                child: Text(
                  tracker != null ? 'Edit →' : 'Isi Sekarang →',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF059669), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tracker != null) ...[
            _buildSholatStatus(tracker),
            const SizedBox(height: 8),
            Text(
              '📖 Tilawah: ${tracker['tilawah']} halaman',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF059669), fontWeight: FontWeight.w600),
            ),
          ] else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Belum ada tracker hari ini. Yuk isi! 🌱',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSholatStatus(Map<String, dynamic> tracker) {
    final sholat = ['shubuh', 'dzuhur', 'ashar', 'maghrib', 'isya'];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: sholat.map((s) {
        final status = tracker[s];
        Color bgColor;
        Color textColor;
        String icon;
        if (status == 'tepat_waktu') {
          bgColor = const Color(0xFFECFDF5);
          textColor = const Color(0xFF059669);
          icon = '✅';
        } else if (status == 'telat') {
          bgColor = const Color(0xFFFEF3C7);
          textColor = const Color(0xFFF59E0B);
          icon = '🕐';
        } else if (status == 'terlewat') {
          bgColor = const Color(0xFFFEE2E2);
          textColor = const Color(0xFFEF4444);
          icon = '❌';
        } else {
          bgColor = const Color(0xFFF3F4F6);
          textColor = const Color(0xFF9CA3AF);
          icon = '—';
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
          child: Text('$icon ${s[0].toUpperCase()}${s.substring(1)}',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
        );
      }).toList(),
    );
  }

  Widget _buildCatatanTerbaru() {
    final catatan = _dashboardData?['catatan_terbaru'] as List? ?? [];
    final moodEmoji = {
      'bersyukur': '😊', 'tenang': '😌', 'biasa': '😐',
      'gelisah': '😟', 'sedih': '😢', 'marah': '😤', 'khawatir': '😰',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('📔 Catatan Terbaru', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 1),
                child: Text('Lihat Semua →', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF059669), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (catatan.isEmpty)
            Center(
              child: Text('Belum ada catatan muhasabah.', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
            )
          else
            ...catatan.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(moodEmoji[item['mood']] ?? '📔', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'], style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(item['tanggal'], style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }
}