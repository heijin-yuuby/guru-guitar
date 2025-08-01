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

  @override
  void initState() {
    super.initState();
    _updateHighlights();
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        size: Size(
          MediaQuery.of(context).size.width - 32,
          300, // 固定高度
        ),
                    painter: FretboardPainter(
              startFret: widget.startFret,
              endFret: widget.endFret,
              highlightedPositions: highlightedPositions,
              chordPositions: chordPositions,
              cagedPositions: cagedPositions,
              showNotes: widget.showNotes,
              showIntervals: widget.showIntervals,
              onFretTap: widget.onFretTap,
            ),
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

  FretboardPainter({
    required this.startFret,
    required this.endFret,
    required this.highlightedPositions,
    required this.chordPositions,
    required this.cagedPositions,
    required this.showNotes,
    required this.showIntervals,
    this.onFretTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fretCount = endFret - startFret + 1;
    final fretHeight = size.height / fretCount; // 竖向：品格是垂直分布
    final stringSpacing = size.width / 7; // 竖向：6根弦横向分布

    // 绘制指板背景
    _drawFretboardBackground(canvas, size);

    // 绘制品丝（横线）
    _drawFrets(canvas, size, fretHeight, fretCount);

    // 绘制琴弦（竖线）
    _drawStrings(canvas, size, stringSpacing);

    // 绘制品格标记 (3, 5, 7, 9, 12品等)
    _drawFretMarkers(canvas, size, fretHeight, stringSpacing);

    // 绘制品格数字
    _drawFretNumbers(canvas, size, fretHeight);

    // 绘制音符/和弦位置
    _drawPositions(canvas, size, fretHeight, stringSpacing);
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

  void _drawFrets(Canvas canvas, Size size, double fretHeight, int fretCount) {
    final fretPaint = Paint()
      ..color = const Color(0xFFCDCDCD) // 银色品丝
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 竖向布局：品丝是横线
    for (int i = 0; i <= fretCount; i++) {
      final y = i * fretHeight;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        fretPaint,
      );
    }
  }

  void _drawStrings(Canvas canvas, Size size, double stringSpacing) {
    final stringPaint = Paint()
      ..color = const Color(0xFF808080)
      ..style = PaintingStyle.stroke;

    // 竖向布局：琴弦是竖线，从6弦到1弦（从左到右）
    for (int i = 1; i <= 6; i++) {
      final x = i * stringSpacing;
      // 不同弦粗细不同（6弦最粗，1弦最细）
      final stringIndex = 7 - i; // 反转弦号，6弦在左，1弦在右
      stringPaint.strokeWidth = stringIndex <= 2 ? 1.0 : (stringIndex <= 4 ? 1.5 : 2.0);
      
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        stringPaint,
      );
    }
  }

  void _drawFretMarkers(Canvas canvas, Size size, double fretHeight, double stringSpacing) {
    final markerPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final markerFrets = [3, 5, 7, 9, 15, 17, 19, 21]; // 单点标记
    final doubleMarkerFrets = [12, 24]; // 双点标记

    for (int fret = startFret; fret <= endFret; fret++) {
      final fretIndex = fret - startFret;
      final centerY = fretIndex * fretHeight + fretHeight / 2;
      final centerX = size.width / 2;

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
          Offset(centerX - 20, centerY),
          8,
          markerPaint,
        );
        canvas.drawCircle(
          Offset(centerX + 20, centerY),
          8,
          markerPaint,
        );
      }
    }
  }

  void _drawFretNumbers(Canvas canvas, Size size, double fretHeight) {
    final textStyle = TextStyle(
      color: const Color(0xFF666666),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    // 竖向布局：品格数字显示在左侧
    for (int fret = startFret; fret <= endFret; fret++) {
      if (fret == 0) continue; // 不显示0品
      
      final fretIndex = fret - startFret;
      final centerY = fretIndex * fretHeight + fretHeight / 2;

      final textPainter = TextPainter(
        text: TextSpan(text: fret.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width - 5,
          centerY - textPainter.height / 2,
        ),
      );
    }
  }

  void _drawPositions(Canvas canvas, Size size, double fretHeight, double stringSpacing) {
    // 绘制音阶位置
    for (final position in highlightedPositions) {
      _drawPosition(canvas, size, position, fretHeight, stringSpacing, 
        const Color(0xFF3B82F6), false);
    }

    // 绘制和弦位置
    for (final position in chordPositions) {
      _drawPosition(canvas, size, position, fretHeight, stringSpacing, 
        const Color(0xFFEF4444), true);
    }
    
    // 绘制CAGED和弦位置
    for (final position in cagedPositions) {
      _drawCAGEDPosition(canvas, size, position, fretHeight, stringSpacing);
    }
  }

  void _drawPosition(
    Canvas canvas,
    Size size,
    FretPosition position,
    double fretHeight,
    double stringSpacing,
    Color color,
    bool isChord,
  ) {
    if (position.fret < startFret || position.fret > endFret) return;

    final fretIndex = position.fret - startFret;
    final y = fretIndex * fretHeight + fretHeight / 2;
    final x = position.stringNumber * stringSpacing;

    // 绘制圆圈
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final radius = isChord ? 12.0 : 10.0;
    
    canvas.drawCircle(Offset(x, y), radius, circlePaint);
    canvas.drawCircle(Offset(x, y), radius, borderPaint);

    // 绘制文字
    if (showNotes || showIntervals) {
      final text = showIntervals && position.interval.isNotEmpty 
          ? position.interval 
          : position.note;
      
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w600,
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
    double fretHeight,
    double stringSpacing,
  ) {
    if (position.fret < startFret || position.fret > endFret) return;

    final fretIndex = position.fret - startFret;
    final y = fretIndex * fretHeight + fretHeight / 2;
    final x = position.string * stringSpacing;

    final color = CAGEDSystem.getFingerTypeColor(position.type);
    final text = CAGEDSystem.getFingerTypeText(position.type);

    // 绘制圆圈
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final radius = position.isRoot ? 16.0 : 14.0;
    
    canvas.drawCircle(Offset(x, y), radius, circlePaint);
    canvas.drawCircle(Offset(x, y), radius, borderPaint);

    // 如果是根音，添加额外的金色边框
    if (position.isRoot) {
      final rootPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(Offset(x, y), radius + 2, rootPaint);
    }

    // 绘制文字
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}