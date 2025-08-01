import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../models/music_theory.dart';
import '../models/guitar.dart';
import '../widgets/fretboard_widget.dart';

enum TrainingMode {
  noteIdentification,
  scalePositions,
  chordShapes,
  intervalTraining,
}

class FretboardTrainerScreen extends StatefulWidget {
  final MusicKey selectedKey;

  const FretboardTrainerScreen({
    super.key,
    required this.selectedKey,
  });

  @override
  State<FretboardTrainerScreen> createState() => _FretboardTrainerScreenState();
}

class _FretboardTrainerScreenState extends State<FretboardTrainerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  TrainingMode _currentMode = TrainingMode.noteIdentification;
  
  // 练习状态
  bool _isTraining = false;
  int _score = 0;
  int _totalQuestions = 0;
  int _timeLeft = 60; // 秒
  String? _currentTargetNote;

  List<FretPosition> _highlightedPositions = [];
  
  // 当前问题
  String _questionText = '';
  String _hintText = '';
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _initializeTraining();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeTraining() {
    switch (_currentMode) {
      case TrainingMode.noteIdentification:
        _initializeNoteIdentification();
        break;
      case TrainingMode.scalePositions:
        _initializeScalePositions();
        break;
      case TrainingMode.chordShapes:
        _initializeChordShapes();
        break;
      case TrainingMode.intervalTraining:
        _initializeIntervalTraining();
        break;
    }
  }

  void _initializeNoteIdentification() {
    final notes = GuitarData.chromaticNotes;
    final randomNote = notes[math.Random().nextInt(notes.length)];
    
    setState(() {
      _currentTargetNote = randomNote;
      _questionText = '找到所有的 $randomNote 音符';
      _hintText = '点击指板上的正确位置';
      _highlightedPositions = [];
    });
  }

  void _initializeScalePositions() {
    final rootNote = widget.selectedKey.note;
    
    setState(() {
      _questionText = '显示 ${widget.selectedKey.name} 音阶';
      _hintText = '学习音阶在指板上的位置';
      _highlightedPositions = GuitarData.getScalePositions(
        rootNote, 
        'major', 
        0, 
        12,
      );
    });
  }

  void _initializeChordShapes() {
    setState(() {
      _questionText = '和弦形状练习';
      _hintText = '学习常用和弦指法';
      _highlightedPositions = [];
    });
  }

  void _initializeIntervalTraining() {
    setState(() {
      _questionText = '音程训练';
      _hintText = '识别不同的音程关系';
      _highlightedPositions = [];
    });
  }

  void _onFretTap(FretPosition position) {
    if (!_isTraining) return;

    setState(() {
      _totalQuestions++;
    });

    switch (_currentMode) {
      case TrainingMode.noteIdentification:
        _handleNoteIdentificationTap(position);
        break;
      case TrainingMode.scalePositions:
        _handleScalePositionTap(position);
        break;
      case TrainingMode.chordShapes:
        _handleChordShapeTap(position);
        break;
      case TrainingMode.intervalTraining:
        _handleIntervalTrainingTap(position);
        break;
    }
  }

  void _handleNoteIdentificationTap(FretPosition position) {
    final isCorrect = position.note == _currentTargetNote;
    
    if (isCorrect) {
      setState(() {
        _score++;
        _highlightedPositions.add(position);
      });
      
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      
      // 显示正确反馈
      _showFeedback(true, '正确！');
      
      // 2秒后生成新问题
      Future.delayed(const Duration(seconds: 2), () {
        if (_isTraining) {
          _initializeNoteIdentification();
        }
      });
    } else {
      _showFeedback(false, '错误，再试试');
    }
  }

  void _handleScalePositionTap(FretPosition position) {
    // 音阶位置练习逻辑
    final scaleNotes = widget.selectedKey.scale;
    final isInScale = scaleNotes.contains(position.note);
    
    if (isInScale) {
      setState(() {
        _score++;
        if (!_highlightedPositions.any((p) => 
            p.stringNumber == position.stringNumber && p.fret == position.fret)) {
          _highlightedPositions.add(position);
        }
      });
      _showFeedback(true, '正确！${position.note} 在音阶中');
    } else {
      _showFeedback(false, '${position.note} 不在 ${widget.selectedKey.name} 中');
    }
  }

  void _handleChordShapeTap(FretPosition position) {
    // 和弦形状练习逻辑
    _showFeedback(true, '和弦练习功能开发中');
  }

  void _handleIntervalTrainingTap(FretPosition position) {
    // 音程训练逻辑
    _showFeedback(true, '音程训练功能开发中');
  }

  void _showFeedback(bool isCorrect, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      backgroundColor: isCorrect 
          ? const Color(0xFF10B981) 
          : const Color(0xFFEF4444),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _startTraining() {
    setState(() {
      _isTraining = true;
      _score = 0;
      _totalQuestions = 0;
      _timeLeft = 60;
    });
    
    _initializeTraining();
    _startTimer();
  }

  void _stopTraining() {
    setState(() {
      _isTraining = false;
    });
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isTraining && _timeLeft > 0 && mounted) {
        setState(() {
          _timeLeft--;
        });
        _startTimer();
      } else if (_timeLeft <= 0 && mounted) {
        _stopTraining();
        _showResults();
      }
    });
  }

  void _showResults() {
    final accuracy = _totalQuestions > 0 
        ? (_score / _totalQuestions * 100).round()
        : 0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '练习结果',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '得分: $_score / $_totalQuestions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '准确率: $accuracy%',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startTraining();
            },
            child: Text(
              '再试一次',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '完成',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          '指板训练器',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isTraining)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_timeLeft}s',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 训练模式选择
          Container(
            margin: const EdgeInsets.all(24),
            child: _buildModeSelector(),
          ),

          // 得分显示
          if (_isTraining)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('得分', '$_score'),
                  _buildStatItem('总数', '$_totalQuestions'),
                  _buildStatItem('准确率', 
                    _totalQuestions > 0 
                        ? '${(_score / _totalQuestions * 100).round()}%'
                        : '0%'),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // 问题显示
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Text(
                        _questionText,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _hintText,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 指板显示
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
                highlightScale: _currentMode == TrainingMode.scalePositions 
                    ? widget.selectedKey.note 
                    : null,
                scaleType: 'major',
                startFret: 0,
                endFret: 12,
                showNotes: true,
                showIntervals: false,
                onFretTap: _onFretTap,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 控制按钮
          Container(
            margin: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTraining ? _stopTraining : _startTraining,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTraining 
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _isTraining ? '停止练习' : '开始练习',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _highlightedPositions.clear();
                    });
                    _initializeTraining();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F0F0),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
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
      child: Row(
        children: TrainingMode.values.map((mode) {
          final isSelected = _currentMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isTraining) {
                  setState(() {
                    _currentMode = mode;
                    _highlightedPositions.clear();
                  });
                  _initializeTraining();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getModeDisplayName(mode),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getModeDisplayName(TrainingMode mode) {
    switch (mode) {
      case TrainingMode.noteIdentification:
        return '音符识别';
      case TrainingMode.scalePositions:
        return '音阶位置';
      case TrainingMode.chordShapes:
        return '和弦形状';
      case TrainingMode.intervalTraining:
        return '音程训练';
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}