import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/muhasabah_model.dart';
import '../../providers/muhasabah_provider.dart';
import 'muhasabah_edit_screen.dart';

class MuhasabahDetailScreen extends StatelessWidget {
  final MuhasabahModel muhasabah;

  const MuhasabahDetailScreen({super.key, required this.muhasabah});

  final Map<String, String> _moodEmoji = const {
    'bersyukur': '😊 Bersyukur',
    'tenang': '😌 Tenang',
    'biasa': '😐 Biasa',
    'gelisah': '😟 Gelisah',
    'sedih': '😢 Sedih',
    'marah': '😤 Marah',
    'khawatir': '😰 Khawatir',
  };

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Catatan'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final result = await context.read<MuhasabahProvider>().deleteMuhasabah(muhasabah.id);
      if (context.mounted) {
        if (result['success']) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catatan berhasil dihapus.'), backgroundColor: Color(0xFF059669)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        title: Text('📖 Detail Muhasabah', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF059669)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MuhasabahEditScreen(muhasabah: muhasabah)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tanggal & Mood
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(muhasabah.tanggal)),
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)),
                  ),
                  if (muhasabah.mood != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Text(
                        _moodEmoji[muhasabah.mood] ?? muhasabah.mood!,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF92400E)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Judul
              Text(
                muhasabah.title,
                style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
              ),
              const Divider(height: 24, color: Color(0xFFE5E7EB)),

              // Isi
              Text(
                muhasabah.content,
                style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF374151), height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}