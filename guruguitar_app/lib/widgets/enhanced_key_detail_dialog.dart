import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/music_theory.dart';
import '../widgets/fretboard_widget.dart';
import '../models/caged_system.dart';


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
    _tabController = TabController(length: 3, vsync: this);
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
          border: Border.all(color: Colors.black, width: 2),
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
                  _buildFretboardMapTab(),
                  _buildCAGEDTab(),
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
        color: Colors.black,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                widget.musicKey.note,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Key signature chips removed for cleaner design
              ],
            ),
          ),
          
          // 关闭按钮
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
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
            ? Colors.white
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.black,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
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
          Tab(text: '指板图谱'),
          Tab(text: 'CAGED'),
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black,
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
        border: Border.all(color: Colors.black),

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
                      color: isRoot ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isRoot ? Colors.black : Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        note,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isRoot ? Colors.white : Colors.black,
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
                      color: Colors.black,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black,
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
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          degreeNames[index],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black,
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
                        color: Colors.black,
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
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            '音程模式：全全半全全全半',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '这是${widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调') ? '自然小调' : '自然大调'}的标准音程排列',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black,
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
        border: Border.all(color: Colors.black),
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
            color: Colors.black,
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
                  color: Colors.black,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 280, // 调整高度以适应紧凑的指板设计
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
                
                // 全屏查看按钮
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => _showFullScreenScaleFretboard(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fullscreen,
                          size: 18,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '横屏查看完整音阶指板图谱',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
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



  Widget _buildCAGEDTab() {
    final rootNote = widget.musicKey.note;
    final cagedChords = CAGEDSystem.getCAGEDChords(rootNote);
    
    // 判断是大调还是小调
    final isMinor = widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调');
    final chordNotes = isMinor 
        ? (MusicTheory.minorChordNotes[rootNote] ?? [])
        : (MusicTheory.majorChordNotes[rootNote] ?? []);
    
    final chordTypeName = isMinor ? '小调和弦' : '大调和弦';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('CAGED系统', '${rootNote}${chordTypeName}的所有指板排列'),
          const SizedBox(height: 16),
          
          // 和弦组成音说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${rootNote}${chordTypeName}组成音',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10), // 减小间距
                Wrap(
                  spacing: 8, // 减小间距
                  runSpacing: 8,
                  children: [
                    _buildChordNoteChip(chordNotes.isNotEmpty ? chordNotes[0] : '', '根音', Colors.black),
                    _buildChordNoteChip(chordNotes.length > 1 ? chordNotes[1] : '', '三度音', Colors.black),
                    _buildChordNoteChip(chordNotes.length > 2 ? chordNotes[2] : '', '五度音', Colors.black),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'CAGED系统基于C、A、G、E、D这五个开放和弦的形状，通过移调在整个指板上演奏${widget.musicKey.name}和弦。每种形状展示了和弦在不同把位的排列。',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black,
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
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          // 简化标题
          Text(
            chord.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
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
        border: Border.all(color: Colors.black),

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
                  color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
              ),
              // 展开按钮
              GestureDetector(
                onTap: () => _showFullFretboard(chord),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.fullscreen,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '展开',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 简化的指板预览图
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Container(
                  height: 250, // 紧凑的高度以适应带有品号弦号标注的指板
                  child: FretboardWidget(
                    cagedChord: chord,
                    startFret: (chord.baseFret - 2).clamp(0, 12),
                    endFret: (chord.baseFret + 4).clamp(4, 15),
                    showNotes: true,
                    showIntervals: false,
                  ),
                ),
                
                // 全屏查看按钮
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => _showFullScreenFretboard(chord),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fullscreen,
                          size: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '横屏查看完整指板',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
        color: Colors.white,
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
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('R', '根音', Colors.black),
              _buildLegendItem('3', '三度音', Colors.black),
              _buildLegendItem('5', '五度音', Colors.black),
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
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildChordNoteChip(String note, String description, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // 减小padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // 稍微减小圆角
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20, // 减小圆形容器尺寸
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                note,
                style: GoogleFonts.inter(
                  fontSize: 11, // 减小字体
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6), // 减小间距
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12, // 减小描述文字字体
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
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
                color: Colors.white,
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
                      Colors.black,
                      Colors.black,
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
                              color: Colors.white,
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
                          color: Colors.white,
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
                            border: Border.all(color: Colors.black),
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
        color: Colors.white,
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
              color: Colors.black,
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
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  '${pos.string}弦-${pos.fret}品',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 12),
          
          // 颜色说明
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('R', '根音', Colors.black),
              _buildLegendItem('3', '三度音', Colors.black),
              _buildLegendItem('5', '五度音', Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  // 显示全屏CAGED指板图谱
  void _showFullScreenFretboard(CAGEDChord chord) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenFretboardView(
          title: '${chord.name} - ${widget.musicKey.name}和弦',
          cagedChord: chord,
        ),
      ),
    );
  }

  // 显示全屏音阶指板图谱
  void _showFullScreenScaleFretboard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenFretboardView(
          title: '${widget.musicKey.name}音阶指板图谱',
          highlightScale: widget.musicKey.note,
          scaleType: widget.musicKey.name.contains('m') || widget.musicKey.name.contains('小调') 
              ? 'minor' 
              : 'major',
        ),
      ),
    );
  }
}

// 全屏指板视图
class FullScreenFretboardView extends StatelessWidget {
  final String title;
  final CAGEDChord? cagedChord;
  final String? highlightScale;
  final String? scaleType;
  const FullScreenFretboardView({
    super.key,
    required this.title,
    this.cagedChord,
    this.highlightScale,
    this.scaleType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 提示文字
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    orientation == Orientation.portrait 
                        ? '💡 旋转手机到横屏模式获得更好的查看体验'
                        : '🎸 横屏模式 - 完整指板图谱',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 指板图谱
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FretboardWidget(
                      cagedChord: cagedChord,
                      highlightScale: highlightScale,
                      scaleType: scaleType ?? 'major',
                      startFret: 0,
                      endFret: 15, // 显示更多品格
                      showNotes: true,
                      showIntervals: false,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 图例说明
                if (cagedChord != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '指法说明',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _buildWhiteLegendItem('R', '根音', Colors.black),
                            _buildWhiteLegendItem('3', '三度音', Colors.black),
                            _buildWhiteLegendItem('5', '五度音', Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWhiteLegendItem(String symbol, String description, Color color) {
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
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}