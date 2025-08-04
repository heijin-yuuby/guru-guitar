import 'package:flutter/material.dart';
import '../models/guitar.dart';
import '../models/caged_system.dart';

class FretboardWidget extends StatefulWidget {
  final String? highlightScale; // 要高亮的音阶根音
  final String? scaleType; // 音阶类型
  final List<GuitarChord>? highlightChords; // 要高亮的和弦
  final CAGEDChord? cagedChord; // CAGED和弦
  final int startFret; // 起始品格
  final int endFret; // 结束品格
  final bool showNotes; // 显示音符名称
  final bool showIntervals; // 显示音程

  final Function(FretPosition)? onFretTap; // 点击品格回调

  const FretboardWidget({
    super.key,
    this.highlightScale,
    this.scaleType = 'major',
    this.highlightChords,
    this.cagedChord,
    this.startFret = 0,
    this.endFret = 12,
    this.showNotes = true,
    this.showIntervals = false,

    this.onFretTap,
  });

  @override
  State<FretboardWidget> createState() => _FretboardWidgetState();
}

class _FretboardWidgetState extends State<FretboardWidget> {
  List<FretPosition> highlightedPositions = [];
  List<FretPosition> chordPositions = [];
  List<CAGEDPosition> cagedPositions = [];
  
  // 同步滚动控制器
  late ScrollController _fretboardScrollController;
  late ScrollController _fretNumberScrollController;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _fretboardScrollController = ScrollController();
    _fretNumberScrollController = ScrollController();
    
    // 设置同步滚动
    _fretboardScrollController.addListener(_syncScrolling);
    _fretNumberScrollController.addListener(_syncScrolling);
    
    _updateHighlights();
  }

  @override
  void dispose() {
    _fretboardScrollController.dispose();
    _fretNumberScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FretboardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlightScale != widget.highlightScale ||
        oldWidget.scaleType != widget.scaleType ||
        oldWidget.highlightChords != widget.highlightChords ||
        oldWidget.cagedChord != widget.cagedChord) {
      _updateHighlights();
    }
  }

  void _updateHighlights() {
    highlightedPositions.clear();
    chordPositions.clear();
    cagedPositions.clear();

    // 更新音阶高亮
    if (widget.highlightScale != null) {
      highlightedPositions = GuitarData.getScalePositions(
        widget.highlightScale!,
        widget.scaleType!,
        widget.startFret,
        widget.endFret,
      );
    }

    // 更新和弦高亮
    if (widget.highlightChords != null) {
      for (final chord in widget.highlightChords!) {
        chordPositions.addAll(chord.positions.where(
          (pos) => pos.fret >= widget.startFret && pos.fret <= widget.endFret,
        ));
      }
    }

    // 更新CAGED和弦高亮
    if (widget.cagedChord != null) {
      cagedPositions = widget.cagedChord!.positions.where(
        (pos) => pos.fret >= widget.startFret && pos.fret <= widget.endFret,
      ).toList();
    }

    setState(() {});
  }
  
  void _syncScrolling() {
    if (_isSyncing) return;
    
    _isSyncing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _fretboardScrollController.hasClients && _fretNumberScrollController.hasClients) {
        final fretboardOffset = _fretboardScrollController.offset;
        final fretNumberOffset = _fretNumberScrollController.offset;
        
        if ((fretboardOffset - fretNumberOffset).abs() > 1.0) {
          _fretNumberScrollController.jumpTo(fretboardOffset);
        }
      }
      _isSyncing = false;
    });
  }

  FretPosition? _getFretPositionFromTap(Offset tapPosition, double fretWidth) {
    final stringSpacing = 180.0 / 7; // 与绘制时保持一致，使用新的高度
    
    // 计算点击的品格
    final fretIndex = (tapPosition.dx / fretWidth).floor();
    final fret = widget.startFret + fretIndex;
    
    // 计算点击的弦
    final stringNumber = (tapPosition.dy / stringSpacing).round();
    
    // 验证点击位置是否有效
    if (fret < widget.startFret || fret > widget.endFret || 
        stringNumber < 1 || stringNumber > 6) {
      return null;
    }
    
    // 获取该位置的音符
    final note = GuitarData.getNoteAtFret(stringNumber, fret);
    
    return FretPosition(
      stringNumber: stringNumber,
      fret: fret,
      note: note,
      interval: '', // 暂时为空，可以根据需要计算
    );
  }

  @override
  Widget build(BuildContext context) {
    final fretCount = widget.endFret - widget.startFret + 1;
    final fretWidth = 80.0; // 每个品格固定宽度
    final fretboardWidth = fretCount * fretWidth;
    final totalWidth = fretboardWidth + 60; // 总宽度 + 弦号标注空间
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8), // 减少垂直padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // 使用最小尺寸
        children: [
          // 弦号标注和指板图的行
          Container(
            height: 180, // 减少高度以避免溢出
            child: Row(
              children: [
                // 弦号标注（固定）
                Container(
                  width: 50,
                  height: 180,
                  child: _buildStringNumbers(),
                ),
                // 指板图（可水平滚动）
                Expanded(
                  child: SingleChildScrollView(
                    controller: _fretboardScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: fretboardWidth,
                      height: 180,
                      child: GestureDetector(
                        onTapDown: (details) {
                          if (widget.onFretTap != null) {
                            final position = _getFretPositionFromTap(details.localPosition, fretWidth);
                            if (position != null) {
                              widget.onFretTap!(position);
                            }
                          }
                        },
                        child: CustomPaint(
                          size: Size(fretboardWidth, 180),
                          painter: FretboardPainter(
                            startFret: widget.startFret,
                            endFret: widget.endFret,
                            highlightedPositions: highlightedPositions,
                            chordPositions: chordPositions,
                            cagedPositions: cagedPositions,
                            showNotes: widget.showNotes,
                            showIntervals: widget.showIntervals,
                            onFretTap: widget.onFretTap,
                            fretWidth: fretWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 品号标注
          Container(
            height: 30, // 减少高度
            child: Row(
              children: [
                // 对齐弦号标注的空间
                const SizedBox(width: 50),
                // 品号标注（可水平滚动）
                Expanded(
                  child: SingleChildScrollView(
                    controller: _fretNumberScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: fretboardWidth,
                      child: _buildFretNumbers(fretWidth),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建弦号标注
  Widget _buildStringNumbers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 6; i++)
          Expanded(
            child: Center(
              child: Text(
                '${i}弦',
                style: const TextStyle(
                  fontSize: 11, // 稍微减小字体
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 构建品号标注
  Widget _buildFretNumbers(double fretWidth) {
    return Container(
      height: 30, // 减少高度
      child: Row(
        children: [
          for (int fret = widget.startFret; fret <= widget.endFret; fret++)
            Container(
              width: fretWidth,
              height: 30, // 减少高度
              child: Center(
                child: Text(
                  '${fret}品',
                  style: const TextStyle(
                    fontSize: 11, // 稍微减小字体
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FretboardPainter extends CustomPainter {
  final int startFret;
  final int endFret;
  final List<FretPosition> highlightedPositions;
  final List<FretPosition> chordPositions;
  final List<CAGEDPosition> cagedPositions;
  final bool showNotes;
  final bool showIntervals;

  final Function(FretPosition)? onFretTap;
  final double fretWidth;

  FretboardPainter({
    required this.startFret,
    required this.endFret,
    required this.highlightedPositions,
    required this.chordPositions,
    required this.cagedPositions,
    required this.showNotes,
    required this.showIntervals,

    this.onFretTap,
    required this.fretWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fretCount = endFret - startFret + 1;
    final stringSpacing = size.height / 7; // 横向：6根弦纵向分布

    // 绘制指板背景
    _drawFretboardBackground(canvas, size);

    // 绘制品丝（竖线）
    _drawFrets(canvas, size, fretWidth, fretCount);

    // 绘制琴弦（横线）
    _drawStrings(canvas, size, stringSpacing);

    // 绘制品格标记 (3, 5, 7, 9, 12品等)
    _drawFretMarkers(canvas, size, fretWidth, stringSpacing);

    // 绘制品格数字
    _drawFretNumbers(canvas, size, fretWidth);

    // 绘制音符/和弦位置
    _drawPositions(canvas, size, fretWidth, stringSpacing);
  }

  void _drawFretboardBackground(Canvas canvas, Size size) {
    // 更现代的指板背景
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF3A3A3A), // 深灰色
        const Color(0xFF2A2A2A), // 更深的灰色
        const Color(0xFF1A1A1A), // 最深的灰色
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(12)),
      Paint()..shader = gradient.createShader(backgroundRect),
    );
    
    // 添加边框
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(12)),
      Paint()
        ..color = const Color(0xFF404040)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  void _drawFrets(Canvas canvas, Size size, double fretWidth, int fretCount) {
    final fretPaint = Paint()
      ..color = const Color(0xFFCDCDCD) // 银色品丝
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 横向布局：品丝是竖线
    for (int i = 0; i <= fretCount; i++) {
      final x = i * fretWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        fretPaint,
      );
    }
  }

  void _drawStrings(Canvas canvas, Size size, double stringSpacing) {
    final stringPaint = Paint()
      ..color = const Color(0xFF808080)
      ..style = PaintingStyle.stroke;

    // 横向布局：琴弦是横线，从1弦到6弦（从上到下）
    for (int i = 1; i <= 6; i++) {
      final y = i * stringSpacing;
      // 不同弦粗细不同（1弦最细，6弦最粗）
      stringPaint.strokeWidth = i <= 2 ? 1.0 : (i <= 4 ? 1.5 : 2.0);
      
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        stringPaint,
      );
    }
  }

  void _drawFretMarkers(Canvas canvas, Size size, double fretWidth, double stringSpacing) {
    final markerPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final markerFrets = [3, 5, 7, 9, 15, 17, 19, 21]; // 单点标记
    final doubleMarkerFrets = [12, 24]; // 双点标记

    for (int fret = startFret; fret <= endFret; fret++) {
      final fretIndex = fret - startFret;
      final centerX = fretIndex * fretWidth + fretWidth / 2;
      final centerY = size.height / 2;

      if (markerFrets.contains(fret)) {
        // 单点标记
        canvas.drawCircle(
          Offset(centerX, centerY),
          8,
          markerPaint,
        );
      } else if (doubleMarkerFrets.contains(fret)) {
        // 双点标记
        canvas.drawCircle(
          Offset(centerX, centerY - 20),
          8,
          markerPaint,
        );
        canvas.drawCircle(
          Offset(centerX, centerY + 20),
          8,
          markerPaint,
        );
      }
    }
  }

  void _drawFretNumbers(Canvas canvas, Size size, double fretWidth) {
    final textStyle = TextStyle(
      color: const Color(0xFF666666),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    // 横向布局：品格数字显示在底部
    for (int fret = startFret; fret <= endFret; fret++) {
      if (fret == 0) continue; // 不显示0品
      
      final fretIndex = fret - startFret;
      final centerX = fretIndex * fretWidth + fretWidth / 2;

      final textPainter = TextPainter(
        text: TextSpan(text: fret.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          size.height + 8,
        ),
      );
    }
  }

  void _drawPositions(Canvas canvas, Size size, double fretWidth, double stringSpacing) {
    // 绘制音阶位置
    for (final position in highlightedPositions) {
      _drawPosition(canvas, size, position, fretWidth, stringSpacing, 
        const Color(0xFF3B82F6), false);
    }

    // 绘制和弦位置
    for (final position in chordPositions) {
      _drawPosition(canvas, size, position, fretWidth, stringSpacing, 
        const Color(0xFFEF4444), true);
    }
    
    // 绘制CAGED和弦位置
    for (final position in cagedPositions) {
      _drawCAGEDPosition(canvas, size, position, fretWidth, stringSpacing);
    }
  }

  void _drawPosition(
    Canvas canvas,
    Size size,
    FretPosition position,
    double fretWidth,
    double stringSpacing,
    Color color,
    bool isChord,
  ) {
    if (position.fret < startFret || position.fret > endFret) return;

    final fretIndex = position.fret - startFret;
    final x = fretIndex * fretWidth + fretWidth / 2;
    final y = position.stringNumber * stringSpacing;

    // 绘制圆圈
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final radius = isChord ? 15.0 : 12.0;
    
    canvas.drawCircle(Offset(x, y), radius, circlePaint);
    canvas.drawCircle(Offset(x, y), radius, borderPaint);

    // 绘制文字
    if (showNotes || showIntervals) {
      final text = showIntervals && position.interval.isNotEmpty 
          ? position.interval 
          : position.note;
      
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      );

      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );
    }

    // 如果是根音，添加特殊标记
    if (position.interval == '1' || 
        (highlightedPositions.isNotEmpty && 
         position.note == highlightedPositions.first.note)) {
      final rootPaint = Paint()
        ..color = const Color(0xFFFFD700) // 金色
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawCircle(Offset(x, y), radius + 2, rootPaint);
    }
  }

  void _drawCAGEDPosition(
    Canvas canvas,
    Size size,
    CAGEDPosition position,
    double fretWidth,
    double stringSpacing,
  ) {
    if (position.fret < startFret || position.fret > endFret) return;

    final fretIndex = position.fret - startFret;
    final x = fretIndex * fretWidth + fretWidth / 2;
    final y = position.string * stringSpacing;

    final color = CAGEDSystem.getFingerTypeColor(position.type);
    final text = CAGEDSystem.getFingerTypeText(position.type);

    // 根据把位添加透明度渐变效果
    final opacity = _getPositionOpacity(position.fret);
    final circleColor = Color.fromRGBO(color.red, color.green, color.blue, opacity);

    // 绘制圆圈
    final circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final radius = position.isRoot ? 18.0 : 16.0;
    
    canvas.drawCircle(Offset(x, y), radius, circlePaint);
    canvas.drawCircle(Offset(x, y), radius, borderPaint);

    // 如果是根音，添加额外的金色边框
    if (position.isRoot) {
      final rootPaint = Paint()
        ..color = Color.fromRGBO(255, 215, 0, opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(Offset(x, y), radius + 2, rootPaint);
    }

    // 绘制文字
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(opacity),
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      ),
    );
  }

  // 根据品格位置计算透明度，低把位更明显
  double _getPositionOpacity(int fret) {
    if (fret <= 3) return 1.0;        // 0-3品：完全不透明
    if (fret <= 7) return 0.8;        // 4-7品：稍微透明
    if (fret <= 12) return 0.6;       // 8-12品：中等透明
    return 0.4;                       // 13品以上：较透明
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}