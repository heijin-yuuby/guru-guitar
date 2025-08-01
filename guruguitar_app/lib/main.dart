import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GuruGuitarApp());
}

class GuruGuitarApp extends StatelessWidget {
  const GuruGuitarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guru Guitar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A1A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      home: const HomeScreen(),
    );
  }
}
