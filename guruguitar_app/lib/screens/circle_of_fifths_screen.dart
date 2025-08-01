import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/circle_of_fifths_widget.dart';
import '../widgets/enhanced_key_detail_dialog.dart';
import '../models/music_theory.dart';
import 'package:google_fonts/google_fonts.dart';

class CircleOfFifthsScreen extends StatefulWidget {
  const CircleOfFifthsScreen({super.key});

  @override
  State<CircleOfFifthsScreen> createState() => _CircleOfFifthsScreenState();
}

class _CircleOfFifthsScreenState extends State<CircleOfFifthsScreen>
    with TickerProviderStateMixin {
  double _rotation = 0.0;
  Offset? _dragStart;
  double? _initialRotation;
  MusicKey? _selectedKey;

  @override
  void initState() {
    super.initState();
  }

  void _onKeySelected(MusicKey key) {
    setState(() {
      _selectedKey = key;
    });
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => EnhancedKeyDetailDialog(musicKey: key),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _initialRotation = _rotation;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_dragStart == null || _initialRotation == null) return;
    
    final delta = details.localPosition - _dragStart!;
    
    setState(() {
      // 只控制旋转
      _rotation = _initialRotation! + delta.dx * 0.5;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _dragStart = null;
    _initialRotation = null;
  }

  void _resetView() {
    setState(() {
      _rotation = 0.0;
      _selectedKey = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 极简标题栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'Circle of Fifths',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _resetView,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 提示文字和选中调名
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Drag to rotate • Tap keys for details',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (_selectedKey != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C5282),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '当前选择: ${_selectedKey!.name}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 五度圈显示区域
            Expanded(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Center(
                  child: Transform.rotate(
                    angle: _rotation * 3.14159 / 180,
                    child: AnimationLimiter(
                      child: CircleOfFifthsWidget(
                        onKeySelected: _onKeySelected,
                        selectedKey: _selectedKey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部状态栏
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                                         child: Text(
                      '${_rotation.toInt()}°',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 