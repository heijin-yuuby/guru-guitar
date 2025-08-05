import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../models/music_theory.dart';
import '../utils/app_localizations.dart';
import 'circle_of_fifths_screen.dart';
import 'scale_practice_screen.dart';
import 'fretboard_trainer_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const CircleOfFifthsScreen(),
    const PracticeHubScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
              _buildNavItem(0, Icons.account_tree_outlined, Icons.account_tree, l10n.get('circle_of_fifths')),
              _buildNavItem(1, Icons.school_outlined, Icons.school, l10n.get('scale_practice')),
              _buildNavItem(2, Icons.settings_outlined, Icons.settings, l10n.get('settings')),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? Colors.white : const Color(0xFF666666),
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 练习中心屏幕
class PracticeHubScreen extends StatefulWidget {
  const PracticeHubScreen({super.key});

  @override
  State<PracticeHubScreen> createState() => _PracticeHubScreenState();
}

class _PracticeHubScreenState extends State<PracticeHubScreen> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.get('scale_practice_title'),
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.get('select_practice_mode'),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              
              // 音符识别卡片
              _buildPracticeCard(
                context,
                l10n.get('note_identification'),
                l10n.get('quick_note_identification'),
                Icons.grid_4x4,
                const Color(0xFF3B82F6),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FretboardTrainerScreen(
                        selectedKey: MusicTheory.circleOfFifths.first,
                        initialMode: TrainingMode.noteIdentification,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // 音程训练卡片
              _buildPracticeCard(
                context,
                l10n.get('interval_training'),
                l10n.get('master_intervals'),
                Icons.trending_up,
                const Color(0xFF10B981),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FretboardTrainerScreen(
                        selectedKey: MusicTheory.circleOfFifths.first,
                        initialMode: TrainingMode.intervalTraining,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // 音阶挑战卡片
              _buildPracticeCard(
                context,
                l10n.get('scale_challenge'),
                l10n.get('master_scales_modes'),
                Icons.music_note,
                const Color(0xFFEF4444),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FretboardTrainerScreen(
                        selectedKey: MusicTheory.circleOfFifths.first,
                        initialMode: TrainingMode.scaleChallenge,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // 快速开始部分
              Text(
                l10n.get('quick_start'),
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildPracticeCard(
                context,
                l10n.get('random_challenge'),
                l10n.get('random_challenge_desc'),
                Icons.flash_on,
                const Color(0xFFFF6B35),
                () {
                  _showRandomChallengeDialog(context, l10n);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  


  void _showRandomChallengeDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.get('random_challenge'),
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.get('select_challenge_type'),
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 20),
            _buildChallengeOption(
              context,
              l10n.get('note_identification'),
              Icons.grid_4x4,
              const Color(0xFF3B82F6),
              () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FretboardTrainerScreen(
                      selectedKey: MusicTheory.circleOfFifths[math.Random().nextInt(MusicTheory.circleOfFifths.length)],
                      initialMode: TrainingMode.noteIdentification,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildChallengeOption(
              context,
              l10n.get('interval_training'),
              Icons.trending_up,
              const Color(0xFF10B981),
              () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FretboardTrainerScreen(
                      selectedKey: MusicTheory.circleOfFifths[math.Random().nextInt(MusicTheory.circleOfFifths.length)],
                      initialMode: TrainingMode.intervalTraining,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildChallengeOption(
              context,
              l10n.get('scale_challenge'),
              Icons.music_note,
              const Color(0xFFEF4444),
              () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FretboardTrainerScreen(
                      selectedKey: MusicTheory.circleOfFifths[math.Random().nextInt(MusicTheory.circleOfFifths.length)],
                      initialMode: TrainingMode.scaleChallenge,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.get('cancel'),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFCCCCCC),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

