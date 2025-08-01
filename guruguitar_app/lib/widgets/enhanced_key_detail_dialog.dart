import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/music_theory.dart';
import '../widgets/fretboard_widget.dart';
import '../models/caged_system.dart';
import '../screens/scale_practice_screen.dart';

class EnhancedKeyDetailDialog extends StatefulWidget {
  final MusicKey musicKey;

  const EnhancedKeyDetailDialog({
    super.key,
    required this.musicKey,
  });

  @override
  State<EnhancedKeyDetailDialog> createState() => _EnhancedKeyDetailDialogState();
}

class _EnhancedKeyDetailDialogState extends State<EnhancedKeyDetailDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            // 增强的标题栏
            _buildEnhancedHeader(),
            
            // 标签页导航
            _buildTabBar(),
            
            // 标签页内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScaleAnalysisTab(),
                  _buildChordProgressionTab(),
                  _buildFretboardMapTab(),
                  _buildCAGEDTab(),
                  _buildPracticeTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    final isMinor = widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调');
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMinor 
              ? [const Color(0xFF2D3748), const Color(0xFF4A5568)]
              : [const Color(0xFF2C5282), const Color(0xFF3182CE)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // 调性图标
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                widget.musicKey.note,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 调性信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.musicKey.name,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isMinor ? 'Natural Minor Scale' : 'Major Scale',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildKeySignatureChip('♯${widget.musicKey.sharps}', widget.musicKey.sharps > 0),
                    const SizedBox(width: 8),
                    _buildKeySignatureChip('♭${widget.musicKey.flats}', widget.musicKey.flats > 0),
                  ],
                ),
              ],
            ),
          ),
          
          // 关闭按钮
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySignatureChip(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.white.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive 
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(isActive ? 1.0 : 0.6),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF2C5282),
        labelColor: const Color(0xFF2C5282),
        unselectedLabelColor: const Color(0xFF666666),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: '音阶分析'),
          Tab(text: '和弦进行'),
          Tab(text: '指板图谱'),
          Tab(text: 'CAGED'),
          Tab(text: '练习'),
        ],
      ),
    );
  }

  Widget _buildScaleAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 音阶构成
          _buildSectionHeader('音阶构成音', '每个音的度数和功能'),
          const SizedBox(height: 16),
          
          _buildScaleDegreesCard(),
          
          const SizedBox(height: 24),
          
          // 音程关系
          _buildSectionHeader('音程关系', '相邻音之间的音程'),
          const SizedBox(height: 16),
          
          _buildIntervalsCard(),
          
          const SizedBox(height: 24),
          
          // 特征音
          _buildSectionHeader('特征音', '调性的重要标识音'),
          const SizedBox(height: 16),
          
          _buildCharacteristicNotesCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildScaleDegreesCard() {
    final degreeNames = widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调')
        ? ['主音', '上主音', '中音', '下属音', '属音', '下中音', '导音']
        : ['主音', '上主音', '中音', '下属音', '属音', '下中音', '导音'];
    
    final romanNumerals = widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调')
        ? ['i', 'ii°', 'III', 'iv', 'v', 'VI', 'VII']
        : ['I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii°'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 音符展示
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            children: widget.musicKey.scale.asMap().entries.map((entry) {
              final index = entry.key;
              final note = entry.value;
              final isRoot = index == 0;
              
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isRoot ? const Color(0xFF2C5282) : const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isRoot ? const Color(0xFF2C5282) : const Color(0xFFE5E5E5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        note,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isRoot ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${index + 1}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // 详细信息
          ...widget.musicKey.scale.asMap().entries.map((entry) {
            final index = entry.key;
            final note = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C5282),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
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
                          note,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          degreeNames[index],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      romanNumerals[index],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C5282),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildIntervalsCard() {
    // 简化版音程显示
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Text(
            '音程模式：全全半全全全半',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '这是${widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调') ? '自然小调' : '自然大调'}的标准音程排列',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicNotesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCharacteristicNote('主音 (Tonic)', widget.musicKey.scale[0], '调性的根基'),
          const SizedBox(height: 12),
          _buildCharacteristicNote('属音 (Dominant)', widget.musicKey.scale[4], '最重要的支撑音'),
          const SizedBox(height: 12),
          _buildCharacteristicNote('下属音 (Subdominant)', widget.musicKey.scale[3], '和声进行的重要音'),
        ],
      ),
    );
  }

  Widget _buildCharacteristicNote(String name, String note, String description) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF2C5282),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              note,
              style: GoogleFonts.inter(
                fontSize: 12,
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
                name,
                style: GoogleFonts.inter(
                  fontSize: 14,
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
      ],
    );
  }

  Widget _buildChordProgressionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('常用和弦 (I-IV-V)', '调内最重要的三个和弦'),
          const SizedBox(height: 16),
          
          // 功能正在完善
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '和弦进行分析功能正在完善中...',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFretboardMapTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('指板音阶图谱', '在吉他指板上显示音阶位置'),
          const SizedBox(height: 16),
          
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E5E5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FretboardWidget(
                highlightScale: widget.musicKey.note,
                scaleType: widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调') 
                    ? 'minor' 
                    : 'major',
                startFret: 0,
                endFret: 12,
                showNotes: true,
                showIntervals: true,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCAGEDTab() {
    final rootNote = widget.musicKey.note;
    final cagedChords = CAGEDSystem.getCAGEDChords(rootNote);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('CAGED系统', '五种基本和弦形状在指板上的所有按法'),
          const SizedBox(height: 16),
          
          Text(
            'CAGED系统基于C、A、G、E、D这五个开放和弦的形状，通过移调在整个指板上演奏${widget.musicKey.name}和弦',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 显示每个CAGED形状
          ...cagedChords.map((chord) => _buildCAGEDChordShape(chord)).toList(),
        ],
      ),
    );
  }

  Widget _buildSimpleCAGEDChordShape(CAGEDChord chord) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          // 简化标题
          Text(
            chord.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C5282),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 竖向指板图
          Expanded(
            child: FretboardWidget(
              cagedChord: chord,
              startFret: (chord.baseFret - 1).clamp(0, 12),
              endFret: (chord.baseFret + 3).clamp(3, 15),
              showNotes: false,
              showIntervals: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCAGEDChordShape(CAGEDChord chord) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和描述
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C5282),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  chord.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '第${chord.baseFret}品位置',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              // 展开按钮
              GestureDetector(
                onTap: () => _showFullFretboard(chord),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.fullscreen,
                        size: 16,
                        color: Color(0xFF2C5282),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '展开',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C5282),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            chord.description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF666666),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 简化的指板预览图
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: FretboardWidget(
              cagedChord: chord,
              startFret: (chord.baseFret - 1).clamp(0, 12),
              endFret: (chord.baseFret + 3).clamp(3, 15),
              showNotes: false,
              showIntervals: false,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 指法说明
          _buildFingeringLegend(),
        ],
      ),
    );
  }

  Widget _buildFingeringLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '指法说明',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('R', '根音', const Color(0xFF2C5282)),
              _buildLegendItem('3', '三度音', const Color(0xFF38A169)),
              _buildLegendItem('5', '五度音', const Color(0xFFD69E2E)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String symbol, String description, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              symbol,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          description,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  void _showFullFretboard(CAGEDChord chord) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2C5282),
                      const Color(0xFF3182CE),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${chord.name} - ${widget.musicKey.name}和弦',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '完整指板视图 - 第${chord.baseFret}品位置',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 完整指板图
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: FretboardWidget(
                            cagedChord: chord,
                            startFret: 0,
                            endFret: 15,
                            showNotes: true,
                            showIntervals: false,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 详细指法说明
                      _buildDetailedFingeringInfo(chord),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedFingeringInfo(CAGEDChord chord) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '详细指法信息',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          
          // 弦位信息
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: chord.positions.map((pos) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Text(
                  '${pos.string}弦-${pos.fret}品',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 12),
          
          // 颜色说明
          Row(
            children: [
              _buildLegendItem('R', '根音', const Color(0xFF2C5282)),
              const SizedBox(width: 16),
              _buildLegendItem('3', '三度音', const Color(0xFF38A169)),
              const SizedBox(width: 16),
              _buildLegendItem('5', '五度音', const Color(0xFFD69E2E)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('练习模式', '针对该调性的专项练习'),
          const SizedBox(height: 16),
          
          _buildPracticeCard(
            '音阶记忆练习',
            '练习${widget.musicKey.name}音阶的记忆',
            Icons.school,
            const Color(0xFF3B82F6),
            () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScalePracticeScreen(
                    selectedKey: widget.musicKey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5E5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
                      fontSize: 14,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFCCCCCC),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}