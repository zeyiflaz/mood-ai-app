/*
 * ----------------------------------------------------------------------------
 * KATMAN: SUNUM KATMANI (Presentation Layer / View)
 * ----------------------------------------------------------------------------
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import '../models/mood_entry.dart';
import '../services/gemini_service.dart';
import '../widgets/glass_card.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _moodController = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = false;
  Map? _result; // Servis Map döndürdüğü için burayı Map yaptık
  List<MoodEntry> _moodHistory = [];
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('mood_history') ?? [];
    setState(() {
      _moodHistory = historyJson
          .map((json) => MoodEntry.fromJson(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _saveToHistory(MoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    _moodHistory.insert(0, entry);
    if (_moodHistory.length > 50) _moodHistory = _moodHistory.sublist(0, 50);

    final historyJson =
        _moodHistory.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList('mood_history', historyJson);
  }

  Future<void> _analyzeMood() async {
    if (_moodController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _result = null;
    });
    _animController.reset();

    try {
      final result = await _geminiService.analyzeMoodAndMotivate(
        _moodController.text.trim(),
      );

      final entry = MoodEntry(
        mood: _moodController.text.trim(),
        emotion: result['emotion']!,
        motivation: result['motivation']!,
        emoji: result['emoji']!,
        timestamp: DateTime.now(),
      );

      await _saveToHistory(entry);

      setState(() {
        _result = result;
        _isLoading = false;
        _moodController.clear();
      });
      _animController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Hata: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Duygularım',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            color: const Color(0xFF880E4F),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.history_edu_rounded, color: Color(0xFF880E4F)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryPage(history: _moodHistory)),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradientBg),
        child: Stack(
          children: [
            // Arka Plan Süsleri
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 60,
                        color: AppTheme.primaryColor.withOpacity(0.3))
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 50,
                        color: AppTheme.secondaryColor.withOpacity(0.3))
                  ],
                ),
              ),
            ),

            // Ana İçerik
            SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildInputArea(),
                    const SizedBox(height: 30),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                    if (_result != null)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(_fadeAnimation),
                          child: _buildResultArea(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Günaydın ☀️'
        : hour < 18
            ? 'İyi Günler 🌤️'
            : 'İyi Akşamlar 🌙';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A148C),
          ),
        ),
        Text(
          'Bugün kalbin sana ne fısıldıyor?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF7B1FA2).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return GlassCard(
      child: Column(
        children: [
          TextField(
            controller: _moodController,
            maxLines: 4,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Örn: Bugün biraz yorgun hissediyorum çünkü...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: _isLoading ? null : _analyzeMood,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Analiz Et',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Text(
            _result!['emoji'] ?? '✨',
            style: const TextStyle(fontSize: 48),
          ),
        ),
        const SizedBox(height: 20),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.psychology_alt,
                      color: AppTheme.secondaryColor),
                  const SizedBox(width: 10),
                  Text(
                    'Duygu Analizi',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Text(
                _result!['emotion'] ?? '',
                style: GoogleFonts.poppins(fontSize: 15, height: 1.6),
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: AppTheme.primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    'Sana Özel Tavsiye',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Text(
                _result!['motivation'] ?? '',
                style: GoogleFonts.poppins(fontSize: 15, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
