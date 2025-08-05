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
  scaleChallenge,
}

enum DifficultyLevel {
  easy,    // 找到2个音符
  medium,  // 找到3个音符
  hard,    // 找到4个音符
}

enum ScaleDifficultyLevel {
  beginner,  // 初级：大小调音阶
  intermediate,  // 中级：中古调式音阶
  advanced,  // 高级：复杂调式音阶
}

class FretboardTrainerScreen extends StatefulWidget {
  final MusicKey selectedKey;
  final TrainingMode? initialMode;

  const FretboardTrainerScreen({
    super.key,
    required this.selectedKey,
    this.initialMode,
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
  AppLocalizations? _l10n;
  
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
    
    // 设置初始模式
    if (widget.initialMode != null) {
      _currentMode = widget.initialMode!;
    }
    
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
      case TrainingMode.scaleChallenge:
        _initializeScaleChallenge();
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
      _updateQuestionText(randomNote);
      _highlightedPositions = [];
    });
  }

  void _updateQuestionText(String note) {
    if (_l10n != null) {
      _questionText = _l10n!.get('find_notes', {'count': _targetNoteCount.toString(), 'note': note});
      final foundCountText = _l10n!.get('found_count', {'found': _foundNoteCount.toString(), 'target': _targetNoteCount.toString()});
      _hintText = _l10n!.get('click_correct_position') + ' ($foundCountText)';
    } else {
      // 如果 _l10n 还没有初始化，使用默认文本
      _questionText = '找到 $_targetNoteCount 个 $note 音符';
      _hintText = '点击指板上的正确位置 (已找到: $_foundNoteCount/$_targetNoteCount)';
    }
  }



  // 音程训练相关状态
  FretPosition? _rootPosition;
  String? _targetInterval;
  List<String> _intervals = ['minor_second', 'major_second', 'minor_third', 'major_third', 'perfect_fourth', 'tritone', 'perfect_fifth', 'minor_sixth', 'major_sixth', 'minor_seventh', 'major_seventh', 'octave'];
  Map<String, int> _intervalSemitones = {
    'minor_second': 1, 'major_second': 2, 'minor_third': 3, 'major_third': 4,
    'perfect_fourth': 5, 'tritone': 6, 'perfect_fifth': 7, 'minor_sixth': 8,
    'major_sixth': 9, 'minor_seventh': 10, 'major_seventh': 11, 'octave': 12,
  };

  // 音阶挑战相关状态
  List<String> _currentScale = [];
  int _currentScaleIndex = 0; // 当前需要点击的音阶音符索引
  List<FretPosition> _scalePositions = []; // 音阶在指板上的所有位置
  bool _showScalePositions = false; // 是否显示音阶位置提示
  ScaleDifficultyLevel _scaleDifficulty = ScaleDifficultyLevel.beginner; // 音阶难度
  List<String> _usedScales = []; // 已使用过的音阶，避免重复

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
      final intervalText = _l10n?.get(targetInterval) ?? targetInterval;
      _questionText = _l10n?.get('find_interval_from_note', {'note': rootNote, 'interval': intervalText}) ?? '找到距离 $rootNote 一个${intervalText}的音符';
      _hintText = _l10n?.get('click_root_then_interval', {'note': rootNote, 'string': rootString.toString(), 'fret': rootFret.toString()}) ?? '先点击根音 $rootNote（第${rootString}弦第${rootFret}品），再点击目标音程';
      _highlightedPositions = [];
      _foundNoteCount = 0; // 重置音符计数
    });
  }

  void _initializeScaleChallenge() {
    // 如果还没有选择难度，显示难度选择提示
    if (!_isTraining) {
      setState(() {
        _questionText = _l10n?.get('select_difficulty_first') ?? '请先选择难度级别';
        _hintText = _l10n?.get('tap_difficulty_button') ?? '点击难度按钮开始';
      });
      return;
    }
    
    // 根据难度选择音阶类型
    final scaleType = _getScaleTypeForDifficulty();
    final rootNote = widget.selectedKey.note;
    
    // 获取音阶音符
    List<String> scaleNotes;
    String scaleName;
    
    switch (_scaleDifficulty) {
      case ScaleDifficultyLevel.beginner:
        // 初级：大小调音阶
        if (scaleType == 'major') {
          scaleNotes = widget.selectedKey.scale;
          scaleName = '${rootNote}大调';
        } else {
          scaleNotes = _getMinorScale(rootNote);
          scaleName = '${rootNote}小调';
        }
        break;
      case ScaleDifficultyLevel.intermediate:
        // 中级：中古调式音阶
        scaleNotes = _getMedievalScale(rootNote, scaleType);
        scaleName = '${rootNote}${_getScaleTypeName(scaleType)}';
        break;
      case ScaleDifficultyLevel.advanced:
        // 高级：复杂调式音阶
        scaleNotes = _getAdvancedScale(rootNote, scaleType);
        scaleName = '${rootNote}${_getScaleTypeName(scaleType)}';
        break;
    }
    
    // 检查是否已经使用过这个音阶
    final scaleKey = '$scaleName:${scaleNotes.join()}';
    if (_usedScales.contains(scaleKey)) {
      // 如果所有音阶都用过了，重置列表
      if (_usedScales.length >= _getMaxScalesForDifficulty()) {
        _usedScales.clear();
      } else {
        // 重新选择音阶
        _initializeScaleChallenge();
        return;
      }
    }
    
    // 添加到已使用列表
    _usedScales.add(scaleKey);
    
    // 获取音阶在指板上的所有位置
    final scalePositions = GuitarData.getScalePositions(rootNote, scaleType, 0, 12);
    
    setState(() {
      _currentScale = scaleNotes;
      _currentScaleIndex = 0;
      _scalePositions = scalePositions;
      _showScalePositions = false;
      _highlightedPositions = [];
      
      // 设置问题文本
      _questionText = _l10n?.get('play_scale_in_order', {'key': scaleName}) ?? '按顺序演奏 $scaleName 音阶';
      _hintText = _l10n?.get('click_next_note', {'note': scaleNotes[0]}) ?? '点击下一个音符: ${scaleNotes[0]}';
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
      case TrainingMode.scaleChallenge:
        _handleScaleChallengeTap(position);
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
        _showFeedback(false, _l10n?.get('already_clicked') ?? '已点击过');
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
        final foundCountText = _l10n?.get('found_count', {'found': _foundNoteCount.toString(), 'target': _targetNoteCount.toString()}) ?? '已找到: $_foundNoteCount/$_targetNoteCount';
        _hintText = (_l10n?.get('click_correct_position') ?? '点击指板上的正确位置') + ' ($foundCountText)';
      });
      
      // 显示正确反馈
      final correctText = _l10n?.get('correct') ?? '正确';
      _showFeedback(true, '$correctText！已找到 $_foundNoteCount/$_targetNoteCount 个');
      
      // 检查是否完成了所有音符的寻找
      if (_foundNoteCount >= _targetNoteCount) {
        setState(() {
          _score++;
          _totalQuestions++;
        });
        
        // 显示完成反馈
        final completeText = _l10n?.get('complete') ?? '完成';
        _showFeedback(true, '$completeText！找到了所有 $_targetNoteCount 个 $_currentTargetNote 音符');
        
        // 2秒后生成新问题
        Future.delayed(const Duration(seconds: 2), () {
          if (_isTraining) {
            _initializeNoteIdentification();
          }
        });
      }
    } else {
      _showFeedback(false, _l10n?.get('error') ?? '错误');
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
      _showFeedback(true, _l10n?.get('root_correct', {'interval': _targetInterval!}) ?? '根音正确！找${_targetInterval}');
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
      
      _showFeedback(true, _l10n?.get('correct') ?? '正确');
      
      // 2秒后生成新问题
      Future.delayed(const Duration(seconds: 2), () {
        if (_isTraining) {
          _initializeIntervalTraining();
        }
      });
    } else {
      _showFeedback(false, _l10n?.get('error') ?? '错误');
    }
  }

  void _handleScaleChallengeTap(FretPosition position) {
    if (_currentScale.isEmpty || _currentScaleIndex >= _currentScale.length) return;
    
    final expectedNote = _currentScale[_currentScaleIndex];
    final clickedNote = position.note;
    
    // 检查是否点击了正确的音符
    if (_notesAreEqual(clickedNote, expectedNote)) {
      setState(() {
        _score++;
        _highlightedPositions.add(position);
        _currentScaleIndex++;
      });
      
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      
      // 检查是否完成了整个音阶
      if (_currentScaleIndex >= _currentScale.length) {
        _showFeedback(true, _l10n?.get('scale_completed') ?? '音阶完成！');
        
        // 2秒后重新开始
        Future.delayed(const Duration(seconds: 2), () {
          if (_isTraining) {
            _initializeScaleChallenge();
          }
        });
      } else {
        // 更新提示文本
        final nextNote = _currentScale[_currentScaleIndex];
        _hintText = _l10n?.get('click_next_note', {'note': nextNote}) ?? '点击下一个音符: $nextNote';
        _showFeedback(true, _l10n?.get('correct') ?? '正确');
      }
    } else {
      _showFeedback(false, _l10n?.get('wrong_note') ?? '错误的音符');
    }
  }

  // 检查两个音符是否相等（考虑等音关系）
  bool _notesAreEqual(String note1, String note2) {
    // 直接比较
    if (note1 == note2) return true;
    
    // 处理等音关系
    final note1Index = _getNoteIndex(note1);
    final note2Index = _getNoteIndex(note2);
    
    return note1Index == note2Index;
  }

  // 获取音符在半音阶中的索引
  int _getNoteIndex(String note) {
    // 处理特殊音符
    final noteMap = {
      // 升号音符
      'E#': 5,   // F
      'B#': 0,   // C
      
      // 降号音符
      'Cb': 11,  // B
      'Fb': 4,   // E
    };
    
    if (noteMap.containsKey(note)) {
      return noteMap[note]!;
    }
    
    // 处理升号
    if (note.contains('#')) {
      final baseName = note.substring(0, 1);
      final baseIndex = GuitarData.chromaticNotes.indexOf(baseName);
      return (baseIndex + 1) % 12;
    }
    
    // 处理降号
    if (note.contains('b')) {
      final baseName = note.substring(0, 1);
      final baseIndex = GuitarData.chromaticNotes.indexOf(baseName);
      return (baseIndex - 1 + 12) % 12;
    }
    
    // 普通音符
    return GuitarData.chromaticNotes.indexOf(note);
  }

  // 根据难度获取音阶类型
  String _getScaleTypeForDifficulty() {
    final random = math.Random();
    
    switch (_scaleDifficulty) {
      case ScaleDifficultyLevel.beginner:
        // 初级：随机选择大调或小调
        return random.nextBool() ? 'major' : 'minor';
      case ScaleDifficultyLevel.intermediate:
        // 中级：中古调式
        final medievalScales = ['dorian', 'mixolydian', 'phrygian', 'lydian'];
        return medievalScales[random.nextInt(medievalScales.length)];
      case ScaleDifficultyLevel.advanced:
        // 高级：复杂调式
        final advancedScales = ['locrian', 'harmonic_minor', 'melodic_minor', 'diminished'];
        return advancedScales[random.nextInt(advancedScales.length)];
    }
  }

  // 获取小调音阶
  List<String> _getMinorScale(String rootNote) {
    final rootIndex = GuitarData.chromaticNotes.indexOf(rootNote);
    final minorIntervals = [0, 2, 3, 5, 7, 8, 10]; // 自然小调音程
    
    return minorIntervals.map((interval) {
      final noteIndex = (rootIndex + interval) % 12;
      return GuitarData.chromaticNotes[noteIndex];
    }).toList();
  }

  // 获取中古调式音阶
  List<String> _getMedievalScale(String rootNote, String scaleType) {
    final rootIndex = GuitarData.chromaticNotes.indexOf(rootNote);
    List<int> intervals;
    
    switch (scaleType) {
      case 'dorian':
        intervals = [0, 2, 3, 5, 7, 9, 10]; // 多利安调式
        break;
      case 'mixolydian':
        intervals = [0, 2, 4, 5, 7, 9, 10]; // 混合利底亚调式
        break;
      case 'phrygian':
        intervals = [0, 1, 3, 5, 7, 8, 10]; // 弗里吉亚调式
        break;
      case 'lydian':
        intervals = [0, 2, 4, 6, 7, 9, 11]; // 利底亚调式
        break;
      default:
        intervals = [0, 2, 4, 5, 7, 9, 11]; // 默认大调
    }
    
    return intervals.map((interval) {
      final noteIndex = (rootIndex + interval) % 12;
      return GuitarData.chromaticNotes[noteIndex];
    }).toList();
  }

  // 获取高级调式音阶
  List<String> _getAdvancedScale(String rootNote, String scaleType) {
    final rootIndex = GuitarData.chromaticNotes.indexOf(rootNote);
    List<int> intervals;
    
    switch (scaleType) {
      case 'locrian':
        intervals = [0, 1, 3, 5, 6, 8, 10]; // 洛克里亚调式
        break;
      case 'harmonic_minor':
        intervals = [0, 2, 3, 5, 7, 8, 11]; // 和声小调
        break;
      case 'melodic_minor':
        intervals = [0, 2, 3, 5, 7, 9, 11]; // 旋律小调
        break;
      case 'diminished':
        intervals = [0, 2, 3, 5, 6, 8, 9]; // 减音阶
        break;
      default:
        intervals = [0, 2, 4, 5, 7, 9, 11]; // 默认大调
    }
    
    return intervals.map((interval) {
      final noteIndex = (rootIndex + interval) % 12;
      return GuitarData.chromaticNotes[noteIndex];
    }).toList();
  }

  // 获取音阶类型名称
  String _getScaleTypeName(String scaleType) {
    switch (scaleType) {
      case 'major':
        return '大调';
      case 'minor':
        return '小调';
      case 'dorian':
        return '多利安调式';
      case 'mixolydian':
        return '混合利底亚调式';
      case 'phrygian':
        return '弗里吉亚调式';
      case 'lydian':
        return '利底亚调式';
      case 'locrian':
        return '洛克里亚调式';
      case 'harmonic_minor':
        return '和声小调';
      case 'melodic_minor':
        return '旋律小调';
      case 'diminished':
        return '减音阶';
      default:
        return '音阶';
    }
  }

  // 获取难度对应的最大音阶数量
  int _getMaxScalesForDifficulty() {
    switch (_scaleDifficulty) {
      case ScaleDifficultyLevel.beginner:
        return 2; // 大调和小调
      case ScaleDifficultyLevel.intermediate:
        return 4; // 4个中古调式
      case ScaleDifficultyLevel.advanced:
        return 4; // 4个高级调式
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
    if (_currentMode == TrainingMode.scaleChallenge) {
      // 音阶挑战模式需要先选择难度
      _showDifficultySelectionDialog(context);
      return;
    }
    
    setState(() {
      _isTraining = true;
      _score = 0;
      _totalQuestions = 0;
      _timeLeft = 60;
      _highlightedPositions.clear();
      _foundNoteCount = 0;
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
          _l10n?.get('practice_result') ?? '练习结果',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_l10n?.get('score') ?? '得分'}: $_score / $_totalQuestions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_l10n?.get('accuracy') ?? '准确率'}: $accuracy%',
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
              _l10n?.get('try_again') ?? '再试一次',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              _l10n?.get('done') ?? '完成',
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
          _l10n?.get('fretboard_trainer') ?? '指板训练器',
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
                  _buildStatItem(_l10n?.get('score') ?? '得分', '$_score'),
                  _buildStatItem(_l10n?.get('total') ?? '总数', '$_totalQuestions'),
                  _buildStatItem(_l10n?.get('accuracy') ?? '准确率', 
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

          // 音阶挑战控制按钮
          if (_currentMode == TrainingMode.scaleChallenge)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 难度选择器
                  ElevatedButton.icon(
                    onPressed: () => _showDifficultySelectionDialog(context),
                    icon: const Icon(Icons.school, size: 18),
                    label: Text(
                      _isTraining 
                          ? _getScaleDifficultyDisplayName(_scaleDifficulty)
                          : (_l10n?.get('select_difficulty') ?? '选择难度'),
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTraining 
                          ? const Color(0xFF3B82F6) 
                          : const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  
                  // 音阶位置显示/隐藏按钮（仅在训练时显示）
                  if (_isTraining)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showScalePositions = !_showScalePositions;
                        });
                      },
                      icon: Icon(
                        _showScalePositions ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                      ),
                      label: Text(
                        _showScalePositions 
                            ? (_l10n?.get('hide_scale_positions') ?? '隐藏音阶位置')
                            : (_l10n?.get('show_scale_positions') ?? '显示音阶位置'),
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showScalePositions 
                            ? const Color(0xFFEF4444) 
                            : const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          if (_currentMode == TrainingMode.scaleChallenge && _isTraining)
            const SizedBox(height: 16),

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
                customHighlightPositions: _currentMode == TrainingMode.scaleChallenge && _showScalePositions 
                    ? _scalePositions 
                    : _highlightedPositions,
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
                      _isTraining ? (_l10n?.get('stop_training') ?? '停止训练') : (_l10n?.get('start_training') ?? '开始训练'),
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
        return _l10n?.get('note_identification') ?? '音符识别';
      case TrainingMode.intervalTraining:
        return _l10n?.get('interval_training') ?? '音程训练';
      case TrainingMode.scaleChallenge:
        return _l10n?.get('scale_challenge') ?? '音阶挑战';
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
        return _l10n?.get('easy') ?? '简单';
      case DifficultyLevel.medium:
        return _l10n?.get('medium') ?? '中等';
      case DifficultyLevel.hard:
        return _l10n?.get('hard') ?? '困难';
    }
  }

  String _getScaleDifficultyDisplayName(ScaleDifficultyLevel difficulty) {
    switch (difficulty) {
      case ScaleDifficultyLevel.beginner:
        return _l10n?.get('beginner') ?? '初级';
      case ScaleDifficultyLevel.intermediate:
        return _l10n?.get('intermediate') ?? '中级';
      case ScaleDifficultyLevel.advanced:
        return _l10n?.get('advanced') ?? '高级';
    }
  }

  void _showDifficultySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _l10n?.get('select_difficulty') ?? '选择难度',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDifficultyOption(
              context,
              ScaleDifficultyLevel.beginner,
              _l10n?.get('beginner') ?? '初级',
              _l10n?.get('beginner_desc') ?? '大小调音阶',
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 12),
            _buildDifficultyOption(
              context,
              ScaleDifficultyLevel.intermediate,
              _l10n?.get('intermediate') ?? '中级',
              _l10n?.get('intermediate_desc') ?? '中古调式音阶',
              const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 12),
            _buildDifficultyOption(
              context,
              ScaleDifficultyLevel.advanced,
              _l10n?.get('advanced') ?? '高级',
              _l10n?.get('advanced_desc') ?? '复杂调式音阶',
              const Color(0xFFEF4444),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              _l10n?.get('cancel') ?? '取消',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyOption(
    BuildContext context,
    ScaleDifficultyLevel difficulty,
    String title,
    String description,
    Color color,
  ) {
    final isSelected = _scaleDifficulty == difficulty;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _scaleDifficulty = difficulty;
          _usedScales.clear(); // 清空已使用音阶列表
          _isTraining = true; // 自动开始训练
        });
        Navigator.of(context).pop();
        _initializeScaleChallenge(); // 重新初始化音阶挑战
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  title.substring(0, 1),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyNoteCount(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return _l10n?.get('notes_count', {'count': '2'}) ?? '2个音符';
      case DifficultyLevel.medium:
        return _l10n?.get('notes_count', {'count': '3'}) ?? '3个音符';
      case DifficultyLevel.hard:
        return _l10n?.get('notes_count', {'count': '4'}) ?? '4个音符';
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