import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/music_theory.dart';
import 'circle_of_fifths_screen.dart';
import 'scale_practice_screen.dart';
import 'chord_progression_screen.dart';
import 'fretboard_trainer_screen.dart';

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
    const FretboardHubScreen(),
    const ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
                _buildNavItem(2, Icons.grid_view_outlined, Icons.grid_view, '指板'),
                _buildNavItem(3, Icons.analytics_outlined, Icons.analytics, '进度'),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '练习中心',
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
              
              // 和弦进行练习卡片
              _buildPracticeCard(
                context,
                '和弦进行',
                '学习常见和弦进行模式',
                Icons.piano,
                const Color(0xFF10B981),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChordProgressionScreen(
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
                          // TODO: 实现随机挑战
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

// 指板中心屏幕
class FretboardHubScreen extends StatelessWidget {
  const FretboardHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '指板工具',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '可视化学习指板知识',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              
              // 功能开发中占位
              Container(
                padding: const EdgeInsets.all(40),
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
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.construction,
                        size: 64,
                        color: const Color(0xFFCCCCCC),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '指板工具开发中',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '即将支持更多指板可视化功能',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 进度屏幕
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '学习进度',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '跟踪你的学习成果',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              
              // 功能开发中占位
              Container(
                padding: const EdgeInsets.all(40),
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
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 64,
                        color: const Color(0xFFCCCCCC),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '进度统计开发中',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '即将支持学习数据分析',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}