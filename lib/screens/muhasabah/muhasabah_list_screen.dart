import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/muhasabah_provider.dart';
import '../../models/muhasabah_model.dart';
import 'muhasabah_create_screen.dart';
import 'muhasabah_detail_screen.dart';

class MuhasabahListScreen extends StatefulWidget {
  const MuhasabahListScreen({super.key});

  @override
  State<MuhasabahListScreen> createState() => _MuhasabahListScreenState();
}

class _MuhasabahListScreenState extends State<MuhasabahListScreen> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, String> _moodEmoji = {
    'bersyukur': '😊',
    'tenang': '😌',
    'biasa': '😐',
    'gelisah': '😟',
    'sedih': '😢',
    'marah': '😤',
    'khawatir': '😰',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MuhasabahProvider>().fetchMuhasabahs(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<MuhasabahProvider>().fetchMuhasabahs();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MuhasabahProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('📔 Catatan Muhasabah', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF059669)),
            onPressed: () => provider.fetchMuhasabahs(refresh: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MuhasabahCreateScreen()));
          if (mounted) provider.fetchMuhasabahs(refresh: true);
        },
        backgroundColor: const Color(0xFF059669),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: provider.isLoading && provider.muhasabahs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF059669)))
          : provider.muhasabahs.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  color: const Color(0xFF059669),
                  onRefresh: () => provider.fetchMuhasabahs(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.muhasabahs.length + (provider.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.muhasabahs.length) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(color: Color(0xFF059669)),
                        ));
                      }
                      return _buildItem(provider.muhasabahs[index], provider);
                    },
                  ),
                ),
    );
  }

  Widget _buildItem(MuhasabahModel item, MuhasabahProvider provider) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => MuhasabahDetailScreen(muhasabah: item),
        ));
        if (mounted) provider.fetchMuhasabahs(refresh: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _moodEmoji[item.mood] ?? '📔',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                      DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(item.tanggal)),
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 4),
                  Text(item.content,
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📔', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text('Belum ada catatan muhasabah.',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF374151))),
          const SizedBox(height: 8),
          Text('Yuk mulai tulis muhasabah pertamamu!',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
        ],
      ),
    );
  }
}