import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/music_theory.dart';

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTapUp: (details) {
            _handleTap(details.localPosition, const Size(400, 400));
          },
          child: CustomPaint(
            size: const Size(400, 400),
            painter: CircleOfFifthsPainter(
              keys: MusicTheory.circleOfFifths,
              animationValue: _animation.value,
              selectedKey: widget.selectedKey,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4 * _animation.value;
    final outerRadius = maxRadius;
    final middleRadius = maxRadius * 0.75;
    final innerRadius = maxRadius * 0.5;
    
    // 检查点击位置距离中心的距离
    final distanceFromCenter = (localPosition - center).distance;
    
    // 判断点击在哪个环上
    if (distanceFromCenter >= innerRadius && distanceFromCenter <= outerRadius) {
      // 计算角度
      final angle = math.atan2(
        localPosition.dy - center.dy,
        localPosition.dx - center.dx,
      );
      
      // 转换为度数并调整到0-360范围
      double degrees = (angle * 180 / math.pi + 90) % 360;
      if (degrees < 0) degrees += 360;
      
      // 确定点击的扇形索引
      final sectorIndex = ((degrees + 15) / 30).floor() % 12;
      
      // 根据距离判断是大调还是小调
      if (distanceFromCenter >= middleRadius) {
        // 外环 - 大调
        final majorKeys = ['C', 'G', 'D', 'A', 'E', 'B', 'F♯', 'C♯', 'A♭', 'E♭', 'B♭', 'F'];
        final keyName = majorKeys[sectorIndex];
        // 处理异名同音调（F♯ = G♭，C♯ = D♭等）
        final actualKeyName = keyName.replaceAll('♯', '#').replaceAll('♭', 'b');
        final musicKey = MusicTheory.circleOfFifths.where((key) => key.note == actualKeyName).isNotEmpty 
            ? MusicTheory.circleOfFifths.where((key) => key.note == actualKeyName).first 
            : null;
        if (musicKey != null) {
          widget.onKeySelected(musicKey);
        }
      } else {
        // 内环 - 小调
        final minorKeys = ['Am', 'Em', 'Bm', 'F♯m', 'C♯m', 'G♯m', 'D♯m', 'A♯m', 'Fm', 'Cm', 'Gm', 'Dm'];
        final keyName = minorKeys[sectorIndex];
        final rootNote = keyName.replaceAll('m', '').replaceAll('♯', '#').replaceAll('♭', 'b');
        
        // 创建小调的MusicKey对象
        final musicKey = MusicKey(
          name: keyName,
          note: rootNote,
          scale: _getMinorScaleForKey(rootNote),
          chords: _getMinorChordsForKey(rootNote),
          sharps: 0,
          flats: 0,
          angle: sectorIndex * 30.0,
        );
        widget.onKeySelected(musicKey);
      }
    }
  }

  // 获取小调音阶的静态方法
  List<String> _getMinorScaleForKey(String rootNote) {
    final chromaticNotes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final rootIndex = chromaticNotes.indexOf(rootNote);
    if (rootIndex == -1) return [];
    
    // 自然小调音程：W-H-W-W-H-W-W
    final intervals = [0, 2, 3, 5, 7, 8, 10];
    return intervals.map((interval) => 
      chromaticNotes[(rootIndex + interval) % 12]
    ).toList();
  }

  // 获取小调和弦的静态方法
  List<String> _getMinorChordsForKey(String rootNote) {
    final scale = _getMinorScaleForKey(rootNote);
    if (scale.isEmpty) return [];
    
    return [
      '${scale[0]}m',  // i
      '${scale[3]}',   // IV
      '${scale[4]}',   // v (or V7)
    ];
  }
}

class CircleOfFifthsPainter extends CustomPainter {
  final List<MusicKey> keys;
  final double animationValue;
  final MusicKey? selectedKey;

  CircleOfFifthsPainter({
    required this.keys,
    required this.animationValue,
    this.selectedKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4 * animationValue;
    
    // 定义多层环形的半径
    final outerRadius = maxRadius;
    final middleRadius = maxRadius * 0.75;
    final innerRadius = maxRadius * 0.5;
    final centerRadius = maxRadius * 0.2;
    
    // 绘制背景
    _drawBackground(canvas, center, maxRadius + 30);
    
    // 绘制外环（大调）
    _drawOuterRing(canvas, center, outerRadius, middleRadius);
    
    // 绘制内环（小调）
    _drawInnerRing(canvas, center, middleRadius, innerRadius);
    
    // 绘制中心区域
    _drawCenter(canvas, center, centerRadius);
  }

  void _drawBackground(Canvas canvas, Offset center, double radius) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF8F9FA)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, backgroundPaint);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double outerRadius, double innerRadius) {
    // 正确的五度圈顺序：C在顶部，顺时针增加升号，逆时针增加降号
    final majorKeys = ['C', 'G', 'D', 'A', 'E', 'B', 'F♯', 'C♯', 'A♭', 'E♭', 'B♭', 'F'];
    
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30.0 - 90) * math.pi / 180 * animationValue; // 从顶部开始
      final startAngle = angle - math.pi / 12; // -15度
      final sweepAngle = math.pi / 6; // 30度
      
      // 获取渐变颜色，如果是选中的调则高亮
      final keyName = majorKeys[i];
      final isSelected = selectedKey != null && 
          selectedKey!.note == keyName.replaceAll('♯', '#').replaceAll('♭', 'b');
      final sectorColor = isSelected 
          ? const Color(0xFFFFD700) // 金色高亮
          : _getOuterSectorColor(i);
      
      // 绘制扇形
      final sectorPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            sectorColor.withOpacity(0.9),
            sectorColor,
            sectorColor.withOpacity(0.8),
          ],
          stops: const [0.0, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
        ..style = PaintingStyle.fill;
      
      // 创建扇形路径
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        )
        ..close();
      
      canvas.drawPath(path, sectorPaint);
      
      // 绘制分割线
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      
      canvas.drawPath(path, borderPaint);
      
      // 绘制文字
      final textAngle = angle;
      final textRadius = (outerRadius + innerRadius) / 2;
      final textX = center.dx + textRadius * math.cos(textAngle);
      final textY = center.dy + textRadius * math.sin(textAngle);
      
      _drawText(
        canvas,
        majorKeys[i],
        Offset(textX, textY),
        20,
        Colors.white,
        FontWeight.w700,
      );
    }
  }

  void _drawInnerRing(Canvas canvas, Offset center, double outerRadius, double innerRadius) {
    // 对应的关系小调：Am对应C大调，Em对应G大调，等等
    final minorKeys = ['Am', 'Em', 'Bm', 'F♯m', 'C♯m', 'G♯m', 'D♯m', 'A♯m', 'Fm', 'Cm', 'Gm', 'Dm'];
    
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30.0 - 90) * math.pi / 180 * animationValue;
      final startAngle = angle - math.pi / 12;
      final sweepAngle = math.pi / 6;
      
      // 获取内环颜色，如果是选中的调则高亮
      final keyName = minorKeys[i];
      final rootNote = keyName.replaceAll('m', '').replaceAll('♯', '#').replaceAll('♭', 'b');
      final isSelected = selectedKey != null && 
          selectedKey!.note == rootNote && selectedKey!.name.contains('m');
      final sectorColor = isSelected 
          ? const Color(0xFFFFD700) // 金色高亮
          : _getInnerSectorColor(i);
      
      // 绘制扇形
      final sectorPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            sectorColor.withOpacity(0.8),
            sectorColor,
            sectorColor.withOpacity(0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
        ..style = PaintingStyle.fill;
      
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        )
        ..close();
      
      canvas.drawPath(path, sectorPaint);
      
      // 绘制分割线
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      
      canvas.drawPath(path, borderPaint);
      
      // 绘制文字
      final textAngle = angle;
      final textRadius = (outerRadius + innerRadius) / 2;
      final textX = center.dx + textRadius * math.cos(textAngle);
      final textY = center.dy + textRadius * math.sin(textAngle);
      
      _drawText(
        canvas,
        minorKeys[i],
        Offset(textX, textY),
        16,
        Colors.white.withOpacity(0.9),
        FontWeight.w600,
      );
    }
  }

  void _drawCenter(Canvas canvas, Offset center, double radius) {
    // 绘制中心圆
    final centerGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2C5282).withOpacity(0.1),
          const Color(0xFF2C5282).withOpacity(0.05),
          Colors.white,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, centerGradient);
    
    // 绘制中心边框
    final centerBorderPaint = Paint()
      ..color = const Color(0xFF2C5282).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawCircle(center, radius, centerBorderPaint);
    
    // 绘制简化的双向箭头
    final arrowPaint = Paint()
      ..color = const Color(0xFF2C5282).withOpacity(0.6)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final arrowLength = radius * 0.5;
    
    // 垂直箭头
    canvas.drawLine(
      Offset(center.dx, center.dy - arrowLength),
      Offset(center.dx, center.dy + arrowLength),
      arrowPaint,
    );
    
    // 上箭头头
    canvas.drawLine(
      Offset(center.dx, center.dy - arrowLength),
      Offset(center.dx - 4, center.dy - arrowLength + 6),
      arrowPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - arrowLength),
      Offset(center.dx + 4, center.dy - arrowLength + 6),
      arrowPaint,
    );
    
    // 下箭头头
    canvas.drawLine(
      Offset(center.dx, center.dy + arrowLength),
      Offset(center.dx - 4, center.dy + arrowLength - 6),
      arrowPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + arrowLength),
      Offset(center.dx + 4, center.dy + arrowLength - 6),
      arrowPaint,
    );
  }

  Color _getOuterSectorColor(int index) {
    // 深蓝色系渐变
    final colors = [
      const Color(0xFF2D3748), // 深灰蓝
      const Color(0xFF2C5282), // 深蓝
      const Color(0xFF2B6CB0), // 中蓝
      const Color(0xFF3182CE), // 亮蓝
      const Color(0xFF319795), // 青色
      const Color(0xFF2C7A7B), // 深青
    ];
    return colors[index % colors.length];
  }

  Color _getInnerSectorColor(int index) {
    // 更深的色调
    final colors = [
      const Color(0xFF1A202C), // 更深灰蓝
      const Color(0xFF1A365D), // 更深蓝
      const Color(0xFF1E4A72), // 深蓝
      const Color(0xFF2A69AC), // 中蓝
      const Color(0xFF285E61), // 深青
      const Color(0xFF234E52), // 更深青
    ];
    return colors[index % colors.length];
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    double fontSize,
    Color color,
    FontWeight fontWeight,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // 添加文字阴影效果
    final shadowPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.3),
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    shadowPainter.layout();
    shadowPainter.paint(
      canvas,
      Offset(
        position.dx - shadowPainter.width / 2 + 1,
        position.dy - shadowPainter.height / 2 + 1,
      ),
    );
    
    // 绘制主文字
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }



  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 