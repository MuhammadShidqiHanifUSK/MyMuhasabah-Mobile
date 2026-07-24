import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/tracker_provider.dart';
import 'tracker_form_screen.dart';

class TrackerCalendarScreen extends StatefulWidget {
  const TrackerCalendarScreen({super.key});

  @override
  State<TrackerCalendarScreen> createState() => _TrackerCalendarScreenState();
}

class _TrackerCalendarScreenState extends State<TrackerCalendarScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTrackers();
    });
  }

  void _fetchTrackers() {
    final bulan = DateFormat('yyyy-MM').format(_currentMonth);
    context.read<TrackerProvider>().fetchTrackers(bulan: bulan);
  }

  void _previousMonth() {
    setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1));
    _fetchTrackers();
  }

  void _nextMonth() {
    if (_currentMonth.year == DateTime.now().year &&
        _currentMonth.month == DateTime.now().month) return;
    setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1));
    _fetchTrackers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrackerProvider>();
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    // Offset hari pertama (Senin = 0)
    int firstWeekday = firstDayOfMonth.weekday - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('✅ Tracker Ibadah', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.today, color: Color(0xFF059669)),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                builder: (_) => TrackerFormScreen(tanggal: DateFormat('yyyy-MM-dd').format(today)),
              ));
              _fetchTrackers();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kalender
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Column(
                children: [
                  // Navigasi Bulan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: const Icon(Icons.chevron_left, color: Color(0xFF059669)),
                      ),
                      Text(
                        DateFormat('MMMM yyyy', 'id').format(_currentMonth),
                        style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: Icon(
                          Icons.chevron_right,
                          color: (_currentMonth.year == today.year && _currentMonth.month == today.month)
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Header Hari
                  Row(
                    children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'].map((h) =>
                      Expanded(
                        child: Center(
                          child: Text(h, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF6B7280))),
                        ),
                      ),
                    ).toList(),
                  ),
                  const SizedBox(height: 8),

                  // Grid Kalender
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: firstWeekday + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) return const SizedBox();

                      final day = index - firstWeekday + 1;
                      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                      final dateStr = DateFormat('yyyy-MM-dd').format(date);
                      final isFuture = date.isAfter(today);
                      final isToday = dateStr == DateFormat('yyyy-MM-dd').format(today);
                      final isFilled = provider.isTanggalTerisi(dateStr);

                      return GestureDetector(
                        onTap: isFuture ? null : () async {
                          await Navigator.push(context, MaterialPageRoute(
                            builder: (_) => TrackerFormScreen(tanggal: dateStr),
                          ));
                          _fetchTrackers();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isFuture
                                ? const Color(0xFFF9FAFB)
                                : isFilled
                                    ? const Color(0xFF059669)
                                    : isToday
                                        ? const Color(0xFFECFDF5)
                                        : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isToday && !isFilled
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFE5E7EB),
                              width: isToday && !isFilled ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isToday || isFilled ? FontWeight.w700 : FontWeight.w400,
                                color: isFuture
                                    ? const Color(0xFFD1D5DB)
                                    : isFilled
                                        ? Colors.white
                                        : isToday
                                            ? const Color(0xFF059669)
                                            : const Color(0xFF111827),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Legend
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legend(const Color(0xFF059669), 'Sudah diisi'),
                      const SizedBox(width: 16),
                      _legend(Colors.white, 'Belum diisi', border: true),
                      const SizedBox(width: 16),
                      _legend(const Color(0xFFF9FAFB), 'Masa depan'),
                    ],
                  ),
                ],
              ),
            ),

            // Riwayat Terbaru
            if (provider.trackers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📋 Riwayat Bulan Ini', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...provider.trackers.take(5).map((tracker) {
                      final sholat = ['shubuh', 'dzuhur', 'ashar', 'maghrib', 'isya'];
                      final sholatCount = sholat.where((s) {
                        final val = s == 'shubuh' ? tracker.shubuh :
                                    s == 'dzuhur' ? tracker.dzuhur :
                                    s == 'ashar' ? tracker.ashar :
                                    s == 'maghrib' ? tracker.maghrib : tracker.isya;
                        return val == 'tepat_waktu' || val == 'telat';
                      }).length;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(tracker.tanggal)),
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text('🕌 $sholatCount/5 sholat', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF059669), fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 12),
                                      Text('📖 ${tracker.tilawah} hal', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => TrackerFormScreen(tanggal: tracker.tanggal),
                                ));
                                _fetchTrackers();
                              },
                              child: Text('Edit →', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF059669), fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String label, {bool border = false}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: border ? Border.all(color: const Color(0xFFE5E7EB)) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280))),
      ],
    );
  }
}