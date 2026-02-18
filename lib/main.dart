
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/app_theme.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Tarih formatı için gerekli başlatma
  await initializeDateFormatting('tr_TR', null);

  // Durum çubuğunu şeffaf yap
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MoodMotivationApp());
}

class MoodMotivationApp extends StatelessWidget {
  const MoodMotivationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        // Renk şemasını Tema dosyasından al
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          secondary: AppTheme.secondaryColor,
        ),
        // Google Fontlarını kullan
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // Ana sayfaya yönlendir
      home: const HomePage(),
    );
  }
}
