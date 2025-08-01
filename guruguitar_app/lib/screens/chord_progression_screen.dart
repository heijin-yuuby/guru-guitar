import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/music_theory.dart';

import '../widgets/fretboard_widget.dart';

class ChordProgressionScreen extends StatefulWidget {
  final MusicKey selectedKey;

  const ChordProgressionScreen({
    super.key,
    required this.selectedKey,
  });

  @override
  State<ChordProgressionScreen> createState() => _ChordProgressionScreenState();
}

class _ChordProgressionScreenState extends State<ChordProgressionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // 常见和弦进行
  final List<Map<String, dynamic>> _commonProgressions = [
    {
      'name': 'I-V-vi-IV',
      'description': '流行摇滚经典',
      'degrees': ['I', 'V', 'vi', 'IV'],
      'example': 'C-G-Am-F',
    },
    {
      'name': 'vi-IV-I-V',
      'description': '情感流行',
      'degrees': ['vi', 'IV', 'I', 'V'],
      'example': 'Am-F-C-G',
    },
    {
      'name': 'I-vi-IV-V',
      'description': '经典摇滚',
      'degrees': ['I', 'vi', 'IV', 'V'],
      'example': 'C-Am-F-G',
    },
    {
      'name': 'ii-V-I',
      'description': '爵士经典',
      'degrees': ['ii', 'V', 'I'],
      'example': 'Dm-G-C',
    },
  ];

  List<String> _selectedProgression = ['I', 'V', 'vi', 'IV'];
  int _currentChordIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 获取调内和弦
  List<String> _getChordInKey(String degree) {
    final key = widget.selectedKey.note;
    switch (degree) {
      case 'I':
        return [key];
      case 'ii':
        return [_transposeNote(key, 2) + 'm'];
      case 'iii':
        return [_transposeNote(key, 4) + 'm'];
      case 'IV':
        return [_transposeNote(key, 5)];
      case 'V':
        return [_transposeNote(key, 7)];
      case 'vi':
        return [_transposeNote(key, 9) + 'm'];
      case 'vii°':
        return [_transposeNote(key, 11) + 'dim'];
      default:
        return [key];
    }
  }

  String _transposeNote(String note, int semitones) {
    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final index = notes.indexOf(note);
    return notes[(index + semitones) % 12];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          '${widget.selectedKey.name} 和弦进行',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // 标签页导航
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
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
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF666666),
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: '进行练习'),
                Tab(text: '指板显示'),
                Tab(text: '自定义'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 标签页内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProgressionPracticeTab(),
                _buildFretboardDisplayTab(),
                _buildCustomProgressionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressionPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 当前进行显示
          Container(
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
            child: Column(
              children: [
                Text(
                  '当前进行',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 和弦显示
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _selectedProgression.asMap().entries.map((entry) {
                    final index = entry.key;
                    final degree = entry.value;
                    final chordName = _getChordInKey(degree).first;
                    final isActive = index == _currentChordIndex;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentChordIndex = index;
                        });
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isActive 
                              ? const Color(0xFF1A1A1A) 
                              : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(
                            color: isActive 
                                ? const Color(0xFF1A1A1A) 
                                : const Color(0xFFE5E5E5),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              degree,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isActive ? Colors.white : const Color(0xFF666666),
                              ),
                            ),
                            Text(
                              chordName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isActive ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // 播放控制
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(
                      Icons.skip_previous,
                      () {
                        setState(() {
                          _currentChordIndex = (_currentChordIndex - 1) % _selectedProgression.length;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildControlButton(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        // TODO: 实现播放功能
                      },
                      isPrimary: true,
                    ),
                    const SizedBox(width: 16),
                    _buildControlButton(
                      Icons.skip_next,
                      () {
                        setState(() {
                          _currentChordIndex = (_currentChordIndex + 1) % _selectedProgression.length;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 常见进行选择
          Text(
            '常见和弦进行',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),

          ..._commonProgressions.map((progression) => 
            _buildProgressionCard(progression)
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isPrimary ? 60 : 50,
        height: isPrimary ? 60 : 50,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(isPrimary ? 30 : 25),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFF1A1A1A),
          size: isPrimary ? 28 : 24,
        ),
      ),
    );
  }

  Widget _buildProgressionCard(Map<String, dynamic> progression) {
    final isSelected = progression['degrees'].toString() == _selectedProgression.toString();
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProgression = List<String>.from(progression['degrees']);
          _currentChordIndex = 0;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFE5E5E5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progression['name'],
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    progression['description'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isSelected 
                          ? Colors.white.withOpacity(0.8) 
                          : const Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progression['example'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                          ? Colors.white.withOpacity(0.9) 
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFretboardDisplayTab() {
    if (_selectedProgression.isEmpty) return const SizedBox();
    
    final currentDegree = _selectedProgression[_currentChordIndex];
    final currentChord = _getChordInKey(currentDegree).first;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前和弦: $currentChord',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '度数: $currentDegree',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 24),
          
          // 指板显示
          Container(
            height: 300,
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
            child: FretboardWidget(
              highlightChords: [
                // TODO: 根据当前和弦获取指板位置
              ],
              startFret: 0,
              endFret: 12,
              showNotes: true,
              showIntervals: false,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 和弦切换器
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '进行中的和弦',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _selectedProgression.asMap().entries.map((entry) {
                    final index = entry.key;
                    final degree = entry.value;
                    final chordName = _getChordInKey(degree).first;
                    final isActive = index == _currentChordIndex;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentChordIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive 
                              ? const Color(0xFF1A1A1A) 
                              : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          chordName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomProgressionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '自定义和弦进行',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '点击下方和弦来创建你的进行',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 24),
          
          // 功能正在开发
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
                    '自定义功能开发中',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '即将支持拖拽创建和弦进行',
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
    );
  }
}