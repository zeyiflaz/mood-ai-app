/*
 * ----------------------------------------------------------------------------
 * KATMAN: SUNUM KATMANI (Presentation Layer / View)
 * ----------------------------------------------------------------------------
 */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';
import '../models/mood_entry.dart';
import '../widgets/glass_card.dart';

class HistoryPage extends StatelessWidget {
  // DÜZELTME BURADA: Listenin tipini <MoodEntry> olarak belirttik.
  final List<MoodEntry> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF880E4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Geçmiş Yolculuğum',
          style: GoogleFonts.poppins(
            color: const Color(0xFF880E4F),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradientBg),
        child: history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off,
                        size: 80, color: Colors.grey.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Text('Henüz bir kayıt yok',
                        style: GoogleFonts.poppins(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.zero,
                    child: ExpansionTile(
                      shape: Border.all(color: Colors.transparent),
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(item.emoji,
                            style: const TextStyle(fontSize: 24)),
                      ),
                      title: Text(
                        DateFormat('d MMMM, EEEE', 'tr_TR')
                            .format(item.timestamp),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        item.mood,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.grey[600], fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Analiz:',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.secondaryColor)),
                              Text(item.emotion,
                                  style: GoogleFonts.poppins(fontSize: 13)),
                              const SizedBox(height: 10),
                              Text('Tavsiye:',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor)),
                              Text(item.motivation,
                                  style: GoogleFonts.poppins(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
