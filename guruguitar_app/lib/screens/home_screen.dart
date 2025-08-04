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
              _buildNavItem(0, Icons.account_tree_outlined, Icons.account_tree, '五度圈'),
              _buildNavItem(1, Icons.school_outlined, Icons.school, '练习'),
              _buildNavItem(2, Icons.settings_outlined, Icons.settings, '设置'),
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
class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

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
                '选择练习模式来提升你的吉他技能',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              
              // 音阶练习卡片
              _buildPracticeCard(
                context,
                '音阶练习',
                '掌握各种音阶和调式',
                Icons.music_note,
                const Color(0xFF3B82F6),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScalePracticeScreen(
                        selectedKey: MusicTheory.circleOfFifths.first,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // 指板训练卡片
              _buildPracticeCard(
                context,
                '指板训练',
                '快速识别指板上的音符',
                Icons.grid_4x4,
                const Color(0xFFEF4444),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FretboardTrainerScreen(
                        selectedKey: MusicTheory.circleOfFifths.first,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // 快速开始部分
              Text(
                '快速开始',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.flash_on,
                      size: 48,
                      color: const Color(0xFFFFB020),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '随机挑战',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '随机生成练习题目，挑战你的极限',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _startRandomChallenge(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB020),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '开始挑战',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRandomChallenge(BuildContext context) {
    final random = math.Random();
    
    // 定义挑战类型和描述
    final challenges = [
      {
        'type': 'note_identification',
        'title': '音符识别挑战',
        'description': '快速识别指板上的音符',
        'icon': Icons.music_note,
        'color': const Color(0xFFEF4444),
      },
      {
        'type': 'scale_practice',
        'title': '音阶练习挑战',
        'description': '掌握音阶的指法和位置',
        'icon': Icons.piano,
        'color': const Color(0xFF3B82F6),
      },
      {
        'type': 'fretboard_training',
        'title': '指板训练挑战',
        'description': '全面训练指板知识',
        'icon': Icons.grid_4x4,
        'color': const Color(0xFF10B981),
      },
    ];
    
    final selectedChallenge = challenges[random.nextInt(challenges.length)];
    final randomKey = MusicTheory.circleOfFifths[random.nextInt(MusicTheory.circleOfFifths.length)];
    
    // 显示挑战预览对话框
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 挑战图标
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: (selectedChallenge['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  selectedChallenge['icon'] as IconData,
                  size: 40,
                  color: selectedChallenge['color'] as Color,
                ),
              ),
              const SizedBox(height: 20),
              
              // 挑战标题
              Text(
                selectedChallenge['title'] as String,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // 挑战描述
              Text(
                selectedChallenge['description'] as String,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // 调性信息
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  '挑战调性: ${randomKey.name}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // 按钮
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: Text(
                        '取消',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _launchChallenge(context, selectedChallenge['type'] as String, randomKey);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedChallenge['color'] as Color,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '开始挑战',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _launchChallenge(BuildContext context, String challengeType, MusicKey key) {
    switch (challengeType) {
      case 'note_identification':
      case 'fretboard_training':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FretboardTrainerScreen(selectedKey: key),
          ),
        );
        break;
      case 'scale_practice':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScalePracticeScreen(selectedKey: key),
          ),
        );
        break;
    }
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

