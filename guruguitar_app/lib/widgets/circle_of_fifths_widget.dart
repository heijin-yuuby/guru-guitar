import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/music_theory.dart';
import '../utils/app_localizations.dart';

enum CircleMode { major, minor }

class CircleOfFifthsWidget extends StatefulWidget {
  final Function(MusicKey) onKeySelected;
  final MusicKey? selectedKey;

  const CircleOfFifthsWidget({
    super.key,
    required this.onKeySelected,
    this.selectedKey,
  });

  @override
  State<CircleOfFifthsWidget> createState() => _CircleOfFifthsWidgetState();
}

class _CircleOfFifthsWidgetState extends State<CircleOfFifthsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // 状态管理
  CircleMode _currentMode = CircleMode.major;
  MusicKey? _selectedKey; // 当前选中的调性

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 大调五度圈数据
  static const List<String> majorKeys = [
    'C', 'G', 'D', 'A', 'E', 'B', 'F#', 'Db', 'Ab', 'Eb', 'Bb', 'F'
  ];
  
  static const List<String> majorKeyNames = [
    'C', 'G', 'D', 'A', 'E', 'B', 'F♯', 'D♭', 'A♭', 'E♭', 'B♭', 'F'
  ];

  // 小调五度圈数据
  static const List<String> minorKeys = [
    'A', 'E', 'B', 'F#', 'C#', 'G#', 'Eb', 'Bb', 'F', 'C', 'G', 'D'
  ];
  
  static const List<String> minorKeyNames = [
    'Am', 'Em', 'Bm', 'F♯m', 'C♯m', 'G♯m', 'E♭m', 'B♭m', 'Fm', 'Cm', 'Gm', 'Dm'
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        // 大小调切换按钮
        _buildModeToggle(),
        const SizedBox(height: 20),
        
        // 五度圈主体
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return GestureDetector(
              onTapUp: (details) {
                _handleTap(details.localPosition, const Size(400, 400));
              },
              child: CustomPaint(
                size: const Size(400, 400),
                painter: CircleOfFifthsPainter(
                  mode: _currentMode,
                  animationValue: _animation.value,
                  selectedKey: _selectedKey ?? widget.selectedKey,
                  majorText: l10n.get('major'),
                  minorText: l10n.get('minor'),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // 提示文字
        Text(
          l10n.get('rotate_circle_instruction'),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeToggle() {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(l10n.get('major'), CircleMode.major),
          _buildToggleButton(l10n.get('minor'), CircleMode.minor),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, CircleMode mode) {
    final isSelected = _currentMode == mode;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // 点击处理
  void _handleKeyTap(int keyIndex) {
    final currentKeys = _currentMode == CircleMode.major ? majorKeys : minorKeys;
    final currentKeyNames = _currentMode == CircleMode.major ? majorKeyNames : minorKeyNames;
    
    if (keyIndex >= 0 && keyIndex < currentKeys.length) {
      final keyNote = currentKeys[keyIndex];
      final keyName = currentKeyNames[keyIndex];
      
      // 创建MusicKey对象
      MusicKey? musicKey;
      
      if (_currentMode == CircleMode.major) {
        final majorKeys = MusicTheory.circleOfFifths.where((key) => 
          key.note == keyNote && !key.name.contains('m'));
        musicKey = majorKeys.isNotEmpty ? majorKeys.first : null;
      } else {
        musicKey = MusicKey(
          name: keyName,
          note: keyNote,
          scale: _getMinorScaleForKey(keyNote),
          chords: _getMinorChordsForKey(keyNote),
          sharps: 0,
          flats: 0,
          angle: keyIndex * 30.0,
        );
      }
      
      if (musicKey != null) {
        setState(() {
          _selectedKey = musicKey;
        });
        widget.onKeySelected(musicKey!);
      }
    }
  }

  void _handleTap(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4 * _animation.value;
    const minRadius = 50.0; // 避免中心区域误触
    final distanceFromCenter = (localPosition - center).distance;
    
    // 检查是否点击在有效的圈内区域
    if (distanceFromCenter <= maxRadius && distanceFromCenter >= minRadius) {
      // 计算点击角度并转换为度数（从顶部开始，0度指向上方）
      final angle = math.atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);
      double degrees = (angle * 180 / math.pi + 90) % 360;
      if (degrees < 0) degrees += 360;
      
      // 计算扇形索引和中心角度
      final sectorIndex = (degrees / 30).floor() % 12;
      final sectorCenterAngle = sectorIndex * 30.0 + 15.0;
      
      // 计算角度差（处理360度循环）
      var angleDiff = (degrees - sectorCenterAngle).abs();
      if (angleDiff > 180) angleDiff = 360 - angleDiff;
      
      // 设置触摸容差：下半圆区域使用更大容差
      final tolerance = (degrees >= 135 && degrees <= 225) ? 15.0 : 12.0;
      
      if (angleDiff <= tolerance) {
        _handleKeyTap(sectorIndex);
      }
    }
  }

  // 获取小调音阶的方法
  List<String> _getMinorScaleForKey(String rootNote) {
    final chromaticNotes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    
    // 处理等音异名
    String normalizedRoot = rootNote;
    if (rootNote == 'Eb') normalizedRoot = 'D#';
    if (rootNote == 'Bb') normalizedRoot = 'A#';
    if (rootNote == 'Db') normalizedRoot = 'C#';
    if (rootNote == 'Ab') normalizedRoot = 'G#';
    if (rootNote == 'Gb') normalizedRoot = 'F#';
    
    final rootIndex = chromaticNotes.indexOf(normalizedRoot);
    if (rootIndex == -1) {
      return [];
    }
    
    // 自然小调音程：W-H-W-W-H-W-W
    final intervals = [0, 2, 3, 5, 7, 8, 10];
    return intervals.map((interval) => 
      chromaticNotes[(rootIndex + interval) % 12]
    ).toList();
  }

  // 获取小调和弦的方法
  List<String> _getMinorChordsForKey(String rootNote) {
    final scale = _getMinorScaleForKey(rootNote);
    if (scale.isEmpty) return [];
    
    return [
      '${scale[0]}m',  // i
      '${scale[3]}',   // IV
      '${scale[4]}',   // v
    ];
  }
}

class CircleOfFifthsPainter extends CustomPainter {
  final CircleMode mode;
  final double animationValue;
  final MusicKey? selectedKey;
  final String majorText;
  final String minorText;

  CircleOfFifthsPainter({
    required this.mode,
    required this.animationValue,
    this.selectedKey,
    required this.majorText,
    required this.minorText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4 * animationValue;
    
    // 绘制背景
    _drawBackground(canvas, center, maxRadius + 40);
    
    // 绘制五度圈环
    _drawCircleRing(canvas, center, maxRadius);
    
    // 绘制中心标题
    _drawCenterTitle(canvas, center);
  }

  void _drawBackground(Canvas canvas, Offset center, double radius) {
    // 白色背景
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    
    // 灰色边框
    canvas.drawCircle(center, radius, Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
  }

  void _drawCircleRing(Canvas canvas, Offset center, double radius) {
    final keys = mode == CircleMode.major 
        ? _CircleOfFifthsWidgetState.majorKeyNames 
        : _CircleOfFifthsWidgetState.minorKeyNames;
    
    const sectorAngle = 2 * math.pi / 12; // 每个扇形30度
    
    for (int i = 0; i < keys.length; i++) {
      final startAngle = (i * sectorAngle) - (math.pi / 2); // 从顶部开始
      final isSelected = selectedKey != null && _isKeyMatch(keys[i], selectedKey!);
      
      // 绘制扇形
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(Rect.fromCircle(center: center, radius: radius), startAngle, sectorAngle, false)
        ..close();
      
      // 填充色：选中为黑色，默认为白色
      canvas.drawPath(path, Paint()
        ..color = isSelected ? Colors.black : Colors.white
        ..style = PaintingStyle.fill);
      
      // 边框
      canvas.drawPath(path, Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
      
      // 绘制调性文字
      final textAngle = startAngle + sectorAngle / 2;
      final textRadius = radius * 0.75;
      final textPosition = Offset(
        center.dx + textRadius * math.cos(textAngle),
        center.dy + textRadius * math.sin(textAngle),
      );
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: keys[i],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      
      textPainter.paint(canvas, Offset(
        textPosition.dx - textPainter.width / 2,
        textPosition.dy - textPainter.height / 2,
      ));
    }
  }

  void _drawCenterTitle(Canvas canvas, Offset center) {
    const centerRadius = 50.0; // 与触摸检测中的 minRadius 保持一致
    
    // 绘制中心圆
    canvas.drawCircle(center, centerRadius, Paint()..color = Colors.white);
    canvas.drawCircle(center, centerRadius, Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
    
    // 绘制标题文字
    final titleText = mode == CircleMode.major ? majorText : minorText;
    final titlePainter = TextPainter(
      text: TextSpan(
        text: titleText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    
    titlePainter.paint(canvas, Offset(
      center.dx - titlePainter.width / 2,
      center.dy - titlePainter.height / 2,
    ));
  }

  bool _isKeyMatch(String displayKey, MusicKey musicKey) {
    if (mode == CircleMode.major) {
      return displayKey.replaceAll('♯', '#').replaceAll('♭', 'b') == musicKey.note;
    } else {
      final rootNote = displayKey.replaceAll('m', '').replaceAll('♯', '#').replaceAll('♭', 'b');
      return rootNote == musicKey.note && musicKey.name.contains('m');
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}