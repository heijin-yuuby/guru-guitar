import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/music_theory.dart';
import '../models/scale_practice.dart';
import '../widgets/scale_practice_widget.dart';

class ScalePracticeScreen extends StatefulWidget {
  final MusicKey selectedKey;

  const ScalePracticeScreen({
    super.key,
    required this.selectedKey,
  });

  @override
  State<ScalePracticeScreen> createState() => _ScalePracticeScreenState();
}

class _ScalePracticeScreenState extends State<ScalePracticeScreen> {
  PracticeMode? selectedMode;

  @override
  Widget build(BuildContext context) {
    final availableModes = ScalePracticeData.getAvailableModes(widget.selectedKey.note);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text('${widget.selectedKey.name} Practice'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Text(
                'Choose Practice Mode',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a mode to practice ${widget.selectedKey.name}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              
              // 练习模式选择
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: availableModes.length,
                  itemBuilder: (context, index) {
                    final mode = availableModes[index];
                    return _buildModeCard(mode);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(PracticeMode mode) {
    final practice = ScalePracticeData.getPractice(widget.selectedKey.note, mode);
    if (practice == null) return const SizedBox.shrink();

    final isSelected = selectedMode == mode;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
        
        // 延迟一下再导航，让用户看到选中效果
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScalePracticeWidget(
                practice: practice,
              ),
            ),
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFE5E5E5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.1 : 0.02),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getModeIcon(mode),
                  color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF666666),
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              
              // 标题
              Text(
                _getModeTitle(mode),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              
              // 描述
              Text(
                practice.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isSelected ? Colors.white.withOpacity(0.7) : const Color(0xFF666666),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // 音符预览
              Row(
                children: practice.notes.take(4).map((note) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        note,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF666666),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getModeIcon(PracticeMode mode) {
    switch (mode) {
      case PracticeMode.majorScale:
        return Icons.music_note;
      case PracticeMode.minorScale:
        return Icons.music_note_outlined;
      case PracticeMode.memoryTest:
        return Icons.psychology;
      case PracticeMode.dorianMode:
        return Icons.tune;
      case PracticeMode.mixolydianMode:
        return Icons.waves;
      case PracticeMode.phrygianMode:
        return Icons.music_off;
      case PracticeMode.lydianMode:
        return Icons.audiotrack;
      case PracticeMode.locrianMode:
        return Icons.graphic_eq;
    }
  }

  String _getModeTitle(PracticeMode mode) {
    switch (mode) {
      case PracticeMode.majorScale:
        return 'Major Scale';
      case PracticeMode.minorScale:
        return 'Minor Scale';
      case PracticeMode.memoryTest:
        return 'Memory Test';
      case PracticeMode.dorianMode:
        return 'Dorian Mode';
      case PracticeMode.mixolydianMode:
        return 'Mixolydian';
      case PracticeMode.phrygianMode:
        return 'Phrygian';
      case PracticeMode.lydianMode:
        return 'Lydian';
      case PracticeMode.locrianMode:
        return 'Locrian';
    }
  }
} 