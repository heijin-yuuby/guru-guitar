import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../models/music_theory.dart';
import '../models/guitar.dart';
import '../widgets/fretboard_widget.dart';
import '../utils/app_localizations.dart';

enum TrainingMode {
  noteIdentification,
  intervalTraining,
}

enum DifficultyLevel {
  easy,    // 找到2个音符
  medium,  // 找到3个音符
  hard,    // 找到4个音符
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
  DifficultyLevel _currentDifficulty = DifficultyLevel.easy;
  
  // 练习状态
  bool _isTraining = false;
  int _score = 0;
  int _totalQuestions = 0;
  int _timeLeft = 60; // 秒
  String? _currentTargetNote;
  int _targetNoteCount = 2; // 需要找到的音符数量
  int _foundNoteCount = 0; // 已经找到的音符数量

  List<FretPosition> _highlightedPositions = [];
  late AppLocalizations _l10n;
  
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context);
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
      case TrainingMode.intervalTraining:
        _initializeIntervalTraining();
        break;
    }
  }

  void _initializeNoteIdentification() {
    final notes = GuitarData.chromaticNotes;
    final randomNote = notes[math.Random().nextInt(notes.length)];
    
    // 根据难度设置目标音符数量
    switch (_currentDifficulty) {
      case DifficultyLevel.easy:
        _targetNoteCount = 2;
        break;
      case DifficultyLevel.medium:
        _targetNoteCount = 3;
        break;
      case DifficultyLevel.hard:
        _targetNoteCount = 4;
        break;
    }
    
    setState(() {
      _currentTargetNote = randomNote;
      _foundNoteCount = 0;
      _questionText = '找到 $_targetNoteCount 个 $randomNote 音符';
      _hintText = '点击指板上的正确位置 (已找到: $_foundNoteCount/$_targetNoteCount)';
      _highlightedPositions = [];
    });
  }



  // 音程训练相关状态
  FretPosition? _rootPosition;
  String? _targetInterval;
  List<String> _intervals = ['小二度', '大二度', '小三度', '大三度', '纯四度', '三全音', '纯五度', '小六度', '大六度', '小七度', '大七度', '八度'];
  Map<String, int> _intervalSemitones = {
    '小二度': 1, '大二度': 2, '小三度': 3, '大三度': 4,
    '纯四度': 5, '三全音': 6, '纯五度': 7, '小六度': 8,
    '大六度': 9, '小七度': 10, '大七度': 11, '八度': 12,
  };

  void _initializeIntervalTraining() {
    final random = math.Random();
    
    // 随机选择根音位置（避免最高品位，确保有足够空间放置音程）
    final rootString = random.nextInt(6) + 1; // 1-6弦
    final rootFret = random.nextInt(8); // 0-7品，留出空间
    final rootNote = GuitarData.getNoteAtFret(rootString, rootFret);
    
    // 随机选择音程
    final targetInterval = _intervals[random.nextInt(_intervals.length)];
    
    setState(() {
      _rootPosition = FretPosition(
        stringNumber: rootString,
        fret: rootFret,
        note: rootNote,
      );
      _targetInterval = targetInterval;
      _questionText = '找到距离 $rootNote 一个$targetInterval的音符';
      _hintText = '先点击根音 $rootNote（第${rootString}弦第${rootFret}品），再点击目标音程';
      _highlightedPositions = [];
      _foundNoteCount = 0; // 重置音符计数
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
      case TrainingMode.intervalTraining:
        _handleIntervalTrainingTap(position);
        break;
    }
  }

  void _handleNoteIdentificationTap(FretPosition position) {
    final isCorrect = position.note == _currentTargetNote;
    
    if (isCorrect) {
      // 检查是否已经点击过这个位置
      final alreadyClicked = _highlightedPositions.any((pos) => 
        pos.stringNumber == position.stringNumber && pos.fret == position.fret);
      
      if (alreadyClicked) {
        _showFeedback(false, _l10n.get('already_clicked'));
        return;
      }
      
      setState(() {
        _foundNoteCount++;
        _highlightedPositions.add(position);
      });
      
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      
      // 更新提示文字
      setState(() {
        _hintText = '点击指板上的正确位置 (已找到: $_foundNoteCount/$_targetNoteCount)';
      });
      
      // 显示正确反馈
      _showFeedback(true, '${_l10n.get('correct')}！已找到 $_foundNoteCount/$_targetNoteCount 个');
      
      // 检查是否完成了所有音符的寻找
      if (_foundNoteCount >= _targetNoteCount) {
        setState(() {
          _score++;
          _totalQuestions++;
        });
        
        // 显示完成反馈
        _showFeedback(true, '${_l10n.get('complete')}！找到了所有 $_targetNoteCount 个 $_currentTargetNote 音符');
        
        // 2秒后生成新问题
        Future.delayed(const Duration(seconds: 2), () {
          if (_isTraining) {
            _initializeNoteIdentification();
          }
        });
      }
    } else {
      _showFeedback(false, _l10n.get('error'));
    }
  }



  void _handleIntervalTrainingTap(FretPosition position) {
    if (_rootPosition == null || _targetInterval == null) return;
    
    // 检查是否点击的是根音位置
    final isRootPosition = position.stringNumber == _rootPosition!.stringNumber && 
                          position.fret == _rootPosition!.fret;
    
    if (isRootPosition) {
      // 点击根音，高亮显示
      setState(() {
        if (!_highlightedPositions.any((p) => 
            p.stringNumber == position.stringNumber && p.fret == position.fret)) {
          _highlightedPositions.add(position);
        }
      });
      _showFeedback(true, _l10n.get('root_correct', {'interval': _targetInterval!}));
      return;
    }
    
    // 计算音程
    final rootNoteIndex = GuitarData.chromaticNotes.indexOf(_rootPosition!.note);
    final clickedNoteIndex = GuitarData.chromaticNotes.indexOf(position.note);
    
    // 计算半音距离（考虑八度内的音程）
    int semitoneDistance = (clickedNoteIndex - rootNoteIndex) % 12;
    if (semitoneDistance == 0 && position.note != _rootPosition!.note) {
      semitoneDistance = 12; // 八度
    }
    
    final expectedSemitones = _intervalSemitones[_targetInterval!]!;
    
    if (semitoneDistance == expectedSemitones) {
      setState(() {
        _score++;
        if (!_highlightedPositions.any((p) => 
            p.stringNumber == position.stringNumber && p.fret == position.fret)) {
          _highlightedPositions.add(position);
        }
      });
      
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      
      _showFeedback(true, _l10n.get('correct'));
      
      // 2秒后生成新问题
      Future.delayed(const Duration(seconds: 2), () {
        if (_isTraining) {
          _initializeIntervalTraining();
        }
      });
    } else {
      _showFeedback(false, _l10n.get('error'));
    }
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
      duration: Duration(milliseconds: isCorrect ? 600 : 300), // 正确提示稍长，错误提示更短
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16), // 添加边距避免遮挡
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
          _l10n.get('practice_result'),
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_l10n.get('score')}: $_score / $_totalQuestions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_l10n.get('accuracy')}: $accuracy%',
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
              _l10n.get('try_again'),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              _l10n.get('done'),
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
          _l10n.get('fretboard_trainer'),
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

          // 难度选择器（仅在音符识别模式下显示）
          if (_currentMode == TrainingMode.noteIdentification)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildDifficultySelector(),
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
                  _buildStatItem(_l10n.get('score'), '$_score'),
                  _buildStatItem(_l10n.get('total'), '$_totalQuestions'),
                  _buildStatItem(_l10n.get('accuracy'), 
                    _totalQuestions > 0 
                        ? '${(_score / _totalQuestions * 100).round()}%'
                        : '0%'),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // 问题显示
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
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
                highlightScale: null,
                scaleType: 'major',
                startFret: 0,
                endFret: 12,
                showNotes: true,
                showIntervals: false,
                onFretTap: _onFretTap,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 控制按钮
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
                      _isTraining ? _l10n.get('stop_training') : _l10n.get('start_training'),
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
                      _foundNoteCount = 0;
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
        return _l10n.get('note_identification');
      case TrainingMode.intervalTraining:
        return _l10n.get('interval_training');
    }
  }

  Widget _buildDifficultySelector() {
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
        children: DifficultyLevel.values.map((difficulty) {
          final isSelected = _currentDifficulty == difficulty;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isTraining) {
                  setState(() {
                    _currentDifficulty = difficulty;
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
                child: Column(
                  children: [
                    Text(
                      _getDifficultyDisplayName(difficulty),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getDifficultyNoteCount(difficulty),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFF999999),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getDifficultyDisplayName(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return _l10n.get('easy');
      case DifficultyLevel.medium:
        return _l10n.get('medium');
      case DifficultyLevel.hard:
        return _l10n.get('hard');
    }
  }

  String _getDifficultyNoteCount(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return '2个音符';
      case DifficultyLevel.medium:
        return '3个音符';
      case DifficultyLevel.hard:
        return '4个音符';
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