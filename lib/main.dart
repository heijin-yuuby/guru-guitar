import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'utils/app_localizations.dart';

void main() {
  runApp(const GuruGuitarApp());
}

class GuruGuitarApp extends StatefulWidget {
  const GuruGuitarApp({super.key});

  @override
  State<GuruGuitarApp> createState() => GuruGuitarAppState();
}

class GuruGuitarAppState extends State<GuruGuitarApp> {
  Locale _locale = const Locale('zh', 'CN');
  static GuruGuitarAppState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
    _loadLanguage();
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selectedLanguage') ?? 'zh';
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  // 静态方法，供设置页面调用
  static void updateLanguage(String languageCode) {
    _instance?.setState(() {
      _instance!._locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guru Guitar',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
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
