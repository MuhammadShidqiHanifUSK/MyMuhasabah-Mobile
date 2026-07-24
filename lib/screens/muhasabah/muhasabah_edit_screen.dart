import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/muhasabah_model.dart';
import '../../providers/muhasabah_provider.dart';

class MuhasabahEditScreen extends StatefulWidget {
  final MuhasabahModel muhasabah;

  const MuhasabahEditScreen({super.key, required this.muhasabah});

  @override
  State<MuhasabahEditScreen> createState() => _MuhasabahEditScreenState();
}

class _MuhasabahEditScreenState extends State<MuhasabahEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _selectedMood;
  late DateTime _selectedDate;

  final List<Map<String, String>> _moods = [
    {'value': 'bersyukur', 'emoji': '😊', 'label': 'Bersyukur'},
    {'value': 'tenang', 'emoji': '😌', 'label': 'Tenang'},
    {'value': 'biasa', 'emoji': '😐', 'label': 'Biasa'},
    {'value': 'gelisah', 'emoji': '😟', 'label': 'Gelisah'},
    {'value': 'sedih', 'emoji': '😢', 'label': 'Sedih'},
    {'value': 'marah', 'emoji': '😤', 'label': 'Marah'},
    {'value': 'khawatir', 'emoji': '😰', 'label': 'Khawatir'},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.muhasabah.title);
    _contentController = TextEditingController(text: widget.muhasabah.content);
    _selectedMood = widget.muhasabah.mood;
    _selectedDate = DateTime.parse(widget.muhasabah.tanggal);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF059669)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MuhasabahProvider>();
    final result = await provider.updateMuhasabah(widget.muhasabah.id, {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'mood': _selectedMood,
      'tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
    });

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil diperbarui! ✨'), backgroundColor: Color(0xFF059669)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: const Color(0xFFEF4444)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MuhasabahProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        title: Text('✏️ Edit Muhasabah', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tanggal
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🗓️ Tanggal', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF9FAFB),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Color(0xFF059669), size: 18),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy', 'id').format(_selectedDate),
                              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF111827)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Mood
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💭 Mood Hari Ini', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: _moods.map((mood) {
                        final isSelected = _selectedMood == mood['value'];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMood = mood['value']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF059669) : const Color(0xFFE5E7EB),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(mood['emoji']!, style: const TextStyle(fontSize: 22)),
                                const SizedBox(height: 2),
                                Text(mood['label']!, style: GoogleFonts.inter(fontSize: 9, color: isSelected ? const Color(0xFF059669) : const Color(0xFF6B7280))),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Judul
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📝 Judul Catatan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration('Judul catatan...'),
                      validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Isi
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📖 Isi Muhasabah', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 8,
                      decoration: _inputDecoration('Ceritakan harimu...'),
                      validator: (v) => v == null || v.isEmpty ? 'Isi catatan wajib diisi' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text('💾 Simpan Perubahan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5)),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
    );
  }
}