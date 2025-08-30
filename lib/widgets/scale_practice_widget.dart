import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scale_practice.dart';

class ScalePracticeWidget extends StatefulWidget {
  final ScalePractice practice;

  const ScalePracticeWidget({
    super.key,
    required this.practice,
  });

  @override
  State<ScalePracticeWidget> createState() => _ScalePracticeWidgetState();
}

class _ScalePracticeWidgetState extends State<ScalePracticeWidget> {
  List<String> userNotes = [];
  List<String> randomizedNotes = [];
  int score = 0;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    _initializePractice();
  }

  void _initializePractice() {
    userNotes = List.filled(widget.practice.notes.length, '');
    randomizedNotes = ScalePracticeData.getRandomizedNotes(
      widget.practice.key,
      widget.practice.mode,
    );
  }

  void _selectNote(String note, int position) {
    setState(() {
      userNotes[position] = note;
    });
  }

  void _checkAnswer() {
    final correctNotes = widget.practice.notes;
    final userAnswer = userNotes.where((note) => note.isNotEmpty).toList();
    
    if (userAnswer.length == correctNotes.length) {
      final calculatedScore = ScalePracticeData.calculateScore(correctNotes, userAnswer);
      setState(() {
        score = calculatedScore;
        showResult = true;
      });
    }
  }

  void _resetPractice() {
    setState(() {
      userNotes = List.filled(widget.practice.notes.length, '');
      randomizedNotes = ScalePracticeData.getRandomizedNotes(
        widget.practice.key,
        widget.practice.mode,
      );
      score = 0;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(widget.practice.description),
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
              Text(
                'Memory Test',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Arrange the notes in the correct order',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              
              if (showResult) ...[
                // 结果显示
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: score >= 80 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        score >= 80 ? Icons.check_circle : Icons.error,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Score: $score%',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        score >= 80 ? 'Excellent!' : 'Keep practicing!',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _resetPractice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // 练习区域
                Expanded(
                  child: Column(
                    children: [
                      // 用户答案区域
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your Answer',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                widget.practice.notes.length,
                                (index) => Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: userNotes[index].isNotEmpty 
                                        ? const Color(0xFF1A1A1A) 
                                        : const Color(0xFFF0F0F0),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: const Color(0xFFE5E5E5)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      userNotes[index].isNotEmpty ? userNotes[index] : '?',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: userNotes[index].isNotEmpty 
                                            ? Colors.white 
                                            : const Color(0xFF999999),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 可选音符
                      Text(
                        'Available Notes',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: randomizedNotes.map((note) {
                          final isUsed = userNotes.contains(note);
                          return GestureDetector(
                            onTap: isUsed ? null : () {
                              final emptyIndex = userNotes.indexWhere((n) => n.isEmpty);
                              if (emptyIndex != -1) {
                                _selectNote(note, emptyIndex);
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isUsed ? const Color(0xFFE5E5E5) : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  note,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isUsed ? const Color(0xFF999999) : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      
                      // 控制按钮
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  userNotes = List.filled(widget.practice.notes.length, '');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0F0F0),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Clear',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: userNotes.every((note) => note.isNotEmpty) 
                                  ? _checkAnswer 
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A1A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Check',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 