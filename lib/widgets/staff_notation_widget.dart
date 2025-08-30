import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/music_theory.dart';

class StaffNotationWidget extends StatelessWidget {
  final MusicKey musicKey;
  final bool showTAB;

  const StaffNotationWidget({
    super.key,
    required this.musicKey,
    this.showTAB = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: showTAB ? 300 : 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: StaffPainter(
          musicKey: musicKey,
          showTAB: showTAB,
        ),
      ),
    );
  }
}

class StaffPainter extends CustomPainter {
  final MusicKey musicKey;
  final bool showTAB;
  
  StaffPainter({
    required this.musicKey,
    required this.showTAB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final staffPaint = Paint()
      ..color = const Color(0xFF333333)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final notesPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    // 绘制五线谱线条
    _drawStaffLines(canvas, size, staffPaint);
    
    // 绘制高音谱号
    _drawTrebleClef(canvas, size);
    
    // 绘制升降号
    _drawKeySignature(canvas, size, staffPaint);
    
    // 绘制音阶音符
    _drawScaleNotes(canvas, size, notesPaint);
    
    // 如果需要，绘制TAB谱
    if (showTAB) {
      _drawTABStaff(canvas, size, staffPaint);
    }
  }

  void _drawStaffLines(Canvas canvas, Size size, Paint paint) {
    final staffTop = size.height * 0.2;
    final staffHeight = size.height * (showTAB ? 0.35 : 0.6);
    final lineSpacing = staffHeight / 4;

    // 绘制五线谱的5条线
    for (int i = 0; i < 5; i++) {
      final y = staffTop + i * lineSpacing;
      canvas.drawLine(
        Offset(size.width * 0.1, y),
        Offset(size.width * 0.9, y),
        paint,
      );
    }
  }

  void _drawTrebleClef(Canvas canvas, Size size) {
    final staffTop = size.height * 0.2;
    final clefX = size.width * 0.15;
    final clefY = staffTop + size.height * 0.15;

    // 简化的高音谱号（用文字表示）
    final textPainter = TextPainter(
      text: TextSpan(
        text: '𝄞',
        style: GoogleFonts.notoMusic(
          fontSize: 48,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(clefX, clefY));
  }

  void _drawKeySignature(Canvas canvas, Size size, Paint paint) {
    final staffTop = size.height * 0.2;
    final lineSpacing = size.height * 0.35 / 4;
    final signatureX = size.width * 0.25;

    // 绘制升号或降号
    if (musicKey.sharps > 0) {
      _drawSharps(canvas, signatureX, staffTop, lineSpacing, musicKey.sharps);
    } else if (musicKey.flats > 0) {
      _drawFlats(canvas, signatureX, staffTop, lineSpacing, musicKey.flats);
    }
  }

  void _drawSharps(Canvas canvas, double x, double staffTop, double lineSpacing, int count) {
    final sharpPositions = [
      staffTop + lineSpacing * 1.5, // F#
      staffTop + lineSpacing * 0.5, // C#
      staffTop + lineSpacing * 2,   // G#
      staffTop + lineSpacing,       // D#
      staffTop + lineSpacing * 2.5, // A#
      staffTop + lineSpacing * 1,   // E#
      staffTop + lineSpacing * 2,   // B#
    ];

    for (int i = 0; i < count && i < sharpPositions.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '♯',
          style: GoogleFonts.notoMusic(
            fontSize: 20,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + i * 15, sharpPositions[i] - 10));
    }
  }

  void _drawFlats(Canvas canvas, double x, double staffTop, double lineSpacing, int count) {
    final flatPositions = [
      staffTop + lineSpacing * 2,   // Bb
      staffTop + lineSpacing * 3,   // Eb
      staffTop + lineSpacing * 1.5, // Ab
      staffTop + lineSpacing * 2.5, // Db
      staffTop + lineSpacing * 2,   // Gb
      staffTop + lineSpacing * 3,   // Cb
      staffTop + lineSpacing * 2.5, // Fb
    ];

    for (int i = 0; i < count && i < flatPositions.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '♭',
          style: GoogleFonts.notoMusic(
            fontSize: 20,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + i * 15, flatPositions[i] - 10));
    }
  }

  void _drawScaleNotes(Canvas canvas, Size size, Paint paint) {
    final staffTop = size.height * 0.2;
    final lineSpacing = size.height * 0.35 / 4;
    final startX = size.width * 0.35;
    final noteSpacing = size.width * 0.07;

    // 音符在五线谱上的位置映射
    final notePositions = _getNotePositions(staffTop, lineSpacing);

    for (int i = 0; i < musicKey.scale.length; i++) {
      final note = musicKey.scale[i];
      final x = startX + i * noteSpacing;
      final y = notePositions[note] ?? staffTop;

      // 绘制音符（简化为圆圈）
      canvas.drawCircle(Offset(x, y), 6, paint);
      
      // 如果音符超出五线谱范围，绘制加线
      _drawLedgerLines(canvas, x, y, staffTop, lineSpacing, paint);
    }
  }

  Map<String, double> _getNotePositions(double staffTop, double lineSpacing) {
    // 五线谱音符位置映射（简化版）
    final positions = <String, double>{};
    final notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
    final baseY = staffTop + lineSpacing * 4; // 第一线下方的C

    for (int i = 0; i < notes.length; i++) {
      positions[notes[i]] = baseY - i * (lineSpacing / 2);
    }

    return positions;
  }

  void _drawLedgerLines(Canvas canvas, double x, double y, double staffTop, double lineSpacing, Paint paint) {
    final firstLine = staffTop;
    final fifthLine = staffTop + lineSpacing * 4;
    
    // 如果音符在五线谱上方或下方，绘制加线
    if (y < firstLine - lineSpacing / 2) {
      // 上方加线
      for (double lineY = firstLine - lineSpacing; lineY >= y - lineSpacing / 2; lineY -= lineSpacing) {
        canvas.drawLine(Offset(x - 10, lineY), Offset(x + 10, lineY), paint);
      }
    } else if (y > fifthLine + lineSpacing / 2) {
      // 下方加线
      for (double lineY = fifthLine + lineSpacing; lineY <= y + lineSpacing / 2; lineY += lineSpacing) {
        canvas.drawLine(Offset(x - 10, lineY), Offset(x + 10, lineY), paint);
      }
    }
  }

  void _drawTABStaff(Canvas canvas, Size size, Paint paint) {
    final tabTop = size.height * 0.65;
    final tabHeight = size.height * 0.25;
    final lineSpacing = tabHeight / 5;

    // 绘制TAB谱的6条线（代表吉他的6根弦）
    for (int i = 0; i < 6; i++) {
      final y = tabTop + i * lineSpacing;
      canvas.drawLine(
        Offset(size.width * 0.1, y),
        Offset(size.width * 0.9, y),
        paint,
      );
    }

    // 绘制"TAB"标识
    final tabTextPainter = TextPainter(
      text: TextSpan(
        text: 'TAB',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    tabTextPainter.layout();
    tabTextPainter.paint(canvas, Offset(size.width * 0.12, tabTop + tabHeight / 3));

    // 绘制品格数字（简化示例）
    _drawTabNumbers(canvas, size, tabTop, lineSpacing);
  }

  void _drawTabNumbers(Canvas canvas, Size size, double tabTop, double lineSpacing) {
    final startX = size.width * 0.35;
    final noteSpacing = size.width * 0.07;

    // 简化的TAB数字示例（实际应该根据音阶计算品格位置）
    final tabNumbers = ['3', '0', '2', '3', '0', '2', '0'];

    for (int i = 0; i < tabNumbers.length && i < musicKey.scale.length; i++) {
      final x = startX + i * noteSpacing;
      final y = tabTop + lineSpacing * 2; // 在第3弦上显示

      final numberPainter = TextPainter(
        text: TextSpan(
          text: tabNumbers[i],
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      numberPainter.layout();
      numberPainter.paint(
        canvas,
        Offset(x - numberPainter.width / 2, y - numberPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}