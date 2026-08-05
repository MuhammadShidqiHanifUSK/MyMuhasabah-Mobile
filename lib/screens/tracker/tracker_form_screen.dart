import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/tracker_provider.dart';

class TrackerFormScreen extends StatefulWidget {
  final String tanggal;

  const TrackerFormScreen({super.key, required this.tanggal});

  @override
  State<TrackerFormScreen> createState() => _TrackerFormScreenState();
}

class _TrackerFormScreenState extends State<TrackerFormScreen> {
  bool _isLoading = true;

  // Sholat Wajib
  String? _shubuh, _dzuhur, _ashar, _maghrib, _isya;

  // Sholat Sunnah
  bool _sunnahQabliyahShubuh = false;
  bool _sunnahQabliyahDzuhur = false;
  bool _sunnahBadiyahDzuhur = false;
  bool _sunnahQabliyahAshar = false;
  bool _sunnahQabliyahMaghrib = false;
  bool _sunnahBadiyahMaghrib = false;
  bool _sunnahQabliyahIsya = false;
  bool _sunnahBadiyahIsya = false;
  bool _tahajud = false;
  bool _dhuha = false;
  bool _witir = false;

  // Amalan Kebaikan
  int _tilawah = 0;
  bool _dzikirPagi = false;
  bool _dzikirPetang = false;
  bool _puasaSunnah = false;
  bool _sedekah = false;
  bool _membantuOrang = false;
  bool _silaturahmi = false;

  // Amal Keburukan
  bool _berkataKotor = false;
  bool _berbohong = false;
  bool _ghibah = false;
  bool _berkataKasar = false;
  bool _merokok = false;
  bool _begadangSiasia = false;
  bool _scrollingBerlebihan = false;
  bool _marahBerlebihan = false;
  bool _iriDengki = false;
  bool _sombong = false;

  final _tilawahController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _loadTracker();
  }

  @override
  void dispose() {
    _tilawahController.dispose();
    super.dispose();
  }

  Future<void> _loadTracker() async {
    await context.read<TrackerProvider>().fetchTracker(widget.tanggal);
    final tracker = context.read<TrackerProvider>().selectedTracker;

    if (tracker != null) {
      setState(() {
        _shubuh = tracker.shubuh;
        _dzuhur = tracker.dzuhur;
        _ashar = tracker.ashar;
        _maghrib = tracker.maghrib;
        _isya = tracker.isya;
        _sunnahQabliyahShubuh = tracker.sunnahQabliyahShubuh;
        _sunnahQabliyahDzuhur = tracker.sunnahQabliyahDzuhur;
        _sunnahBadiyahDzuhur = tracker.sunnahBadiyahDzuhur;
        _sunnahQabliyahAshar = tracker.sunnahQabliyahAshar;
        _sunnahQabliyahMaghrib = tracker.sunnahQabliyahMaghrib;
        _sunnahBadiyahMaghrib = tracker.sunnahBadiyahMaghrib;
        _sunnahQabliyahIsya = tracker.sunnahQabliyahIsya;
        _sunnahBadiyahIsya = tracker.sunnahBadiyahIsya;
        _tahajud = tracker.tahajud;
        _dhuha = tracker.dhuha;
        _witir = tracker.witir;
        _tilawah = tracker.tilawah;
        _tilawahController.text = tracker.tilawah.toString();
        _dzikirPagi = tracker.dzikirPagi;
        _dzikirPetang = tracker.dzikirPetang;
        _puasaSunnah = tracker.puasaSunnah;
        _sedekah = tracker.sedekah;
        _membantuOrang = tracker.membantuOrang;
        _silaturahmi = tracker.silaturahmi;
        _berkataKotor = tracker.berkataKotor;
        _berbohong = tracker.berbohong;
        _ghibah = tracker.ghibah;
        _berkataKasar = tracker.berkataKasar;
        _merokok = tracker.merokok;
        _begadangSiasia = tracker.begadangSiasia;
        _scrollingBerlebihan = tracker.scrollingBerlebihan;
        _marahBerlebihan = tracker.marahBerlebihan;
        _iriDengki = tracker.iriDengki;
        _sombong = tracker.sombong;
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _submit() async {
    final data = {
      'shubuh': _shubuh,
      'dzuhur': _dzuhur,
      'ashar': _ashar,
      'maghrib': _maghrib,
      'isya': _isya,
      'sunnah_qabliyah_shubuh': _sunnahQabliyahShubuh,
      'sunnah_qabliyah_dzuhur': _sunnahQabliyahDzuhur,
      'sunnah_badiyah_dzuhur': _sunnahBadiyahDzuhur,
      'sunnah_qabliyah_ashar': _sunnahQabliyahAshar,
      'sunnah_qabliyah_maghrib': _sunnahQabliyahMaghrib,
      'sunnah_badiyah_maghrib': _sunnahBadiyahMaghrib,
      'sunnah_qabliyah_isya': _sunnahQabliyahIsya,
      'sunnah_badiyah_isya': _sunnahBadiyahIsya,
      'tahajud': _tahajud,
      'dhuha': _dhuha,
      'witir': _witir,
      'tilawah': int.tryParse(_tilawahController.text) ?? 0,
      'dzikir_pagi': _dzikirPagi,
      'dzikir_petang': _dzikirPetang,
      'puasa_sunnah': _puasaSunnah,
      'sedekah': _sedekah,
      'membantu_orang': _membantuOrang,
      'silaturahmi': _silaturahmi,
      'berkata_kotor': _berkataKotor,
      'berbohong': _berbohong,
      'ghibah': _ghibah,
      'berkata_kasar': _berkataKasar,
      'merokok': _merokok,
      'begadang_siasia': _begadangSiasia,
      'scrolling_berlebihan': _scrollingBerlebihan,
      'marah_berlebihan': _marahBerlebihan,
      'iri_dengki': _iriDengki,
      'sombong': _sombong,
    };

    final result = await context.read<TrackerProvider>().saveTracker(widget.tanggal, data);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tracker berhasil disimpan! ✨'), backgroundColor: Color(0xFF059669)),
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
    final tanggalFormatted = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(widget.tanggal));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        title: Text('✅ Tracker Ibadah', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('💾 Simpan Tracker', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF059669)))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanggal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Text(
                      '🗓️ $tanggalFormatted',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF047857)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sholat Wajib
                  _buildCard(
                    title: '🕌 Sholat Wajib',
                    subtitle: 'Pilih status sholat wajib hari ini — jujur ya! 🤍',
                    child: Column(
                      children: [
                        _buildSholatWajib('Shubuh', _shubuh, (v) => setState(() => _shubuh = v)),
                        _buildSholatWajib('Dzuhur', _dzuhur, (v) => setState(() => _dzuhur = v)),
                        _buildSholatWajib('Ashar', _ashar, (v) => setState(() => _ashar = v)),
                        _buildSholatWajib('Maghrib', _maghrib, (v) => setState(() => _maghrib = v)),
                        _buildSholatWajib('Isya', _isya, (v) => setState(() => _isya = v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Sholat Sunnah
                  _buildCard(
                    title: '🌙 Sholat Sunnah',
                    child: Column(
                      children: [
                        _buildCheckItem("Qabliyah Shubuh", _sunnahQabliyahShubuh, (v) => setState(() => _sunnahQabliyahShubuh = v!)),
                        _buildCheckItem("Qabliyah Dzuhur", _sunnahQabliyahDzuhur, (v) => setState(() => _sunnahQabliyahDzuhur = v!)),
                        _buildCheckItem("Ba'diyah Dzuhur", _sunnahBadiyahDzuhur, (v) => setState(() => _sunnahBadiyahDzuhur = v!)),
                        _buildCheckItem("Qabliyah Ashar", _sunnahQabliyahAshar, (v) => setState(() => _sunnahQabliyahAshar = v!)),
                        _buildCheckItem("Qabliyah Maghrib", _sunnahQabliyahMaghrib, (v) => setState(() => _sunnahQabliyahMaghrib = v!)),
                        _buildCheckItem("Ba'diyah Maghrib", _sunnahBadiyahMaghrib, (v) => setState(() => _sunnahBadiyahMaghrib = v!)),
                        _buildCheckItem("Qabliyah Isya", _sunnahQabliyahIsya, (v) => setState(() => _sunnahQabliyahIsya = v!)),
                        _buildCheckItem("Ba'diyah Isya", _sunnahBadiyahIsya, (v) => setState(() => _sunnahBadiyahIsya = v!)),
                        _buildCheckItem("Tahajud", _tahajud, (v) => setState(() => _tahajud = v!)),
                        _buildCheckItem("Dhuha", _dhuha, (v) => setState(() => _dhuha = v!)),
                        _buildCheckItem("Witir", _witir, (v) => setState(() => _witir = v!)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tilawah
                  _buildCard(
                    title: '📖 Tilawah Al-Quran',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tilawahController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5)),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('halaman hari ini', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Amalan Kebaikan Lainnya
                  _buildCard(
                    title: '💚 Amalan Kebaikan Lainnya',
                    child: Column(
                      children: [
                        _buildCheckItem("Dzikir Pagi", _dzikirPagi, (v) => setState(() => _dzikirPagi = v!)),
                        _buildCheckItem("Dzikir Petang", _dzikirPetang, (v) => setState(() => _dzikirPetang = v!)),
                        _buildCheckItem("Puasa Sunnah", _puasaSunnah, (v) => setState(() => _puasaSunnah = v!)),
                        _buildCheckItem("Sedekah", _sedekah, (v) => setState(() => _sedekah = v!)),
                        _buildCheckItem("Membantu Orang", _membantuOrang, (v) => setState(() => _membantuOrang = v!)),
                        _buildCheckItem("Silaturahmi", _silaturahmi, (v) => setState(() => _silaturahmi = v!)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Amal Keburukan
                  _buildCard(
                    title: '⚠️ Amal Keburukan',
                    subtitle: 'Jujurlah pada diri sendiri. Muhasabah yang sejati dimulai dari kejujuran. 🤍',
                    isBad: true,
                    child: Column(
                      children: [
                        _buildCheckItem("Berkata Kotor", _berkataKotor, (v) => setState(() => _berkataKotor = v!), isBad: true),
                        _buildCheckItem("Berbohong", _berbohong, (v) => setState(() => _berbohong = v!), isBad: true),
                        _buildCheckItem("Ghibah", _ghibah, (v) => setState(() => _ghibah = v!), isBad: true),
                        _buildCheckItem("Berkata Kasar", _berkataKasar, (v) => setState(() => _berkataKasar = v!), isBad: true),
                        _buildCheckItem("Merokok", _merokok, (v) => setState(() => _merokok = v!), isBad: true),
                        _buildCheckItem("Begadang Sia-sia", _begadangSiasia, (v) => setState(() => _begadangSiasia = v!), isBad: true),
                        _buildCheckItem("Scrolling Berlebihan", _scrollingBerlebihan, (v) => setState(() => _scrollingBerlebihan = v!), isBad: true),
                        _buildCheckItem("Marah Berlebihan", _marahBerlebihan, (v) => setState(() => _marahBerlebihan = v!), isBad: true),
                        _buildCheckItem("Iri/Dengki", _iriDengki, (v) => setState(() => _iriDengki = v!), isBad: true),
                        _buildCheckItem("Sombong", _sombong, (v) => setState(() => _sombong = v!), isBad: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }

  Widget _buildCard({required String title, String? subtitle, required Widget child, bool isBad = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isBad ? const Color(0xFFFCA5A5) : const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: isBad ? const Color(0xFFEF4444) : const Color(0xFF111827))),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280))),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSholatWajib(String label, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🕌 $label', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              _sholatOption('Tepat Waktu', 'tepat_waktu', value, onChanged, const Color(0xFF059669), const Color(0xFFECFDF5)),
              const SizedBox(width: 6),
              _sholatOption('Telat', 'telat', value, onChanged, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
              const SizedBox(width: 6),
              _sholatOption('Terlewat', 'terlewat', value, onChanged, const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sholatOption(String label, String val, String? current, Function(String?) onChanged, Color color, Color bgColor) {
    final isSelected = current == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(isSelected ? null : val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? bgColor : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? color : const Color(0xFFE5E7EB), width: isSelected ? 1.5 : 1),
          ),
          child: Center(
            child: Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: isSelected ? color : const Color(0xFF6B7280))),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String label, bool value, Function(bool?) onChanged, {bool isBad = false}) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: isBad ? const Color(0xFFEF4444) : const Color(0xFF059669),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF111827))),
          ],
        ),
      ),
    );
  }
}