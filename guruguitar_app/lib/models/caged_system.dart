import 'package:flutter/material.dart';

class CAGEDChord {
  final String name; // C, A, G, E, D
  final String description;
  final List<CAGEDPosition> positions;
  final int baseFret; // 基础品格位置

  CAGEDChord({
    required this.name,
    required this.description,
    required this.positions,
    this.baseFret = 0,
  });
}

class CAGEDPosition {
  final int string; // 弦号 (1-6, 1是最细的弦)
  final int fret; // 品格号
  final CAGEDFingerType type;
  final String? note; // 音符名称
  final bool isRoot; // 是否为根音

  CAGEDPosition({
    required this.string,
    required this.fret,
    required this.type,
    this.note,
    this.isRoot = false,
  });
}

enum CAGEDFingerType {
  root,       // 根音
  third,      // 三度音
  fifth,      // 五度音
  barre,      // 横按
  open,       // 空弦
  muted,      // 闷音
}

class CAGEDSystem {
  // 获取指定调的所有CAGED和弦形状
  static List<CAGEDChord> getCAGEDChords(String rootNote) {
    // 十二平均律
    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final rootIndex = notes.indexOf(rootNote);
    if (rootIndex == -1) return [];

    // 计算各种CAGED形状在指板上的位置
    return [
      _getCShape(rootNote, rootIndex),
      _getAShape(rootNote, rootIndex),
      _getGShape(rootNote, rootIndex),
      _getEShape(rootNote, rootIndex),
      _getDShape(rootNote, rootIndex),
    ];
  }

  // C形状和弦
  static CAGEDChord _getCShape(String rootNote, int rootIndex) {
    // C和弦在第3品的位置计算
    int baseFret = (rootIndex + 12 - 0) % 12; // 相对于C的偏移
    if (baseFret == 0) baseFret = 8; // C调使用8品位置
    
    return CAGEDChord(
      name: 'C形状',
      description: '基于C和弦的指型，适合中等把位演奏',
      baseFret: baseFret,
      positions: [
        CAGEDPosition(string: 5, fret: baseFret + 3, type: CAGEDFingerType.root, isRoot: true),
        CAGEDPosition(string: 4, fret: baseFret + 2, type: CAGEDFingerType.fifth),
        CAGEDPosition(string: 3, fret: baseFret, type: CAGEDFingerType.root),
        CAGEDPosition(string: 2, fret: baseFret + 1, type: CAGEDFingerType.third),
        CAGEDPosition(string: 1, fret: baseFret, type: CAGEDFingerType.root),
      ],
    );
  }

  // A形状和弦
  static CAGEDChord _getAShape(String rootNote, int rootIndex) {
    // A和弦形状，横按指型 - A在开放位置，所以根音在5弦
    int baseFret = (rootIndex + 12 - 9) % 12; // 相对于A的偏移
    if (baseFret == 0) baseFret = 5; // A调使用5品位置
    
    return CAGEDChord(
      name: 'A形状',
      description: '基于A和弦的横按指型，音色饱满',
      baseFret: baseFret,
      positions: [
        CAGEDPosition(string: 5, fret: baseFret, type: CAGEDFingerType.root, isRoot: true),
        CAGEDPosition(string: 4, fret: baseFret + 2, type: CAGEDFingerType.fifth),
        CAGEDPosition(string: 3, fret: baseFret + 2, type: CAGEDFingerType.third),
        CAGEDPosition(string: 2, fret: baseFret + 2, type: CAGEDFingerType.root),
        CAGEDPosition(string: 1, fret: baseFret, type: CAGEDFingerType.fifth),
      ],
    );
  }

  // G形状和弦
  static CAGEDChord _getGShape(String rootNote, int rootIndex) {
    // G和弦形状 - G在3品6弦，根音在6弦3品和1弦3品
    int baseFret = (rootIndex + 12 - 7) % 12; // 相对于G的偏移
    if (baseFret == 0) baseFret = 10; // G调使用10品位置
    
    return CAGEDChord(
      name: 'G形状',
      description: '基于G和弦的指型，低音厚重',
      baseFret: baseFret,
      positions: [
        CAGEDPosition(string: 6, fret: baseFret + 3, type: CAGEDFingerType.root, isRoot: true),
        CAGEDPosition(string: 5, fret: baseFret + 2, type: CAGEDFingerType.fifth),
        CAGEDPosition(string: 4, fret: baseFret, type: CAGEDFingerType.third),
        CAGEDPosition(string: 3, fret: baseFret, type: CAGEDFingerType.root),
        CAGEDPosition(string: 1, fret: baseFret + 3, type: CAGEDFingerType.root),
      ],
    );
  }

  // E形状和弦
  static CAGEDChord _getEShape(String rootNote, int rootIndex) {
    // E和弦形状，横按指型 - E在开放位置，根音在6弦
    int baseFret = (rootIndex + 12 - 4) % 12; // 相对于E的偏移
    if (baseFret == 0) baseFret = 3; // E调使用3品位置
    
    return CAGEDChord(
      name: 'E形状',
      description: '基于E和弦的横按指型，最常用的形状',
      baseFret: baseFret,
      positions: [
        CAGEDPosition(string: 6, fret: baseFret, type: CAGEDFingerType.root, isRoot: true),
        CAGEDPosition(string: 5, fret: baseFret + 2, type: CAGEDFingerType.fifth),
        CAGEDPosition(string: 4, fret: baseFret + 2, type: CAGEDFingerType.root),
        CAGEDPosition(string: 3, fret: baseFret + 1, type: CAGEDFingerType.third),
        CAGEDPosition(string: 2, fret: baseFret, type: CAGEDFingerType.fifth),
        CAGEDPosition(string: 1, fret: baseFret, type: CAGEDFingerType.root),
      ],
    );
  }

  // D形状和弦
  static CAGEDChord _getDShape(String rootNote, int rootIndex) {
    // D和弦形状 - D在2品4弦，根音在4弦2品
    int baseFret = (rootIndex + 12 - 2) % 12; // 相对于D的偏移
    if (baseFret == 0) baseFret = 7; // D调使用7品位置
    
    return CAGEDChord(
      name: 'D形状',
      description: '基于D和弦的指型，高音清亮',
      baseFret: baseFret,
      positions: [
        CAGEDPosition(string: 4, fret: baseFret, type: CAGEDFingerType.root, isRoot: true),
        CAGEDPosition(string: 3, fret: baseFret + 2, type: CAGEDFingerType.fifth),
        CAGEDPosition(string: 2, fret: baseFret + 3, type: CAGEDFingerType.root),
        CAGEDPosition(string: 1, fret: baseFret + 2, type: CAGEDFingerType.third),
      ],
    );
  }

  // 获取指型的颜色
  static Color getFingerTypeColor(CAGEDFingerType type) {
    switch (type) {
      case CAGEDFingerType.root:
        return const Color(0xFF2C5282); // 深蓝色 - 根音
      case CAGEDFingerType.third:
        return const Color(0xFF38A169); // 绿色 - 三度音
      case CAGEDFingerType.fifth:
        return const Color(0xFFD69E2E); // 橙色 - 五度音
      case CAGEDFingerType.barre:
        return const Color(0xFF9F7AEA); // 紫色 - 横按
      case CAGEDFingerType.open:
        return const Color(0xFF718096); // 灰色 - 空弦
      case CAGEDFingerType.muted:
        return const Color(0xFFE53E3E); // 红色 - 闷音
    }
  }

  // 获取指型的显示文本
  static String getFingerTypeText(CAGEDFingerType type) {
    switch (type) {
      case CAGEDFingerType.root:
        return 'R';
      case CAGEDFingerType.third:
        return '3';
      case CAGEDFingerType.fifth:
        return '5';
      case CAGEDFingerType.barre:
        return 'B';
      case CAGEDFingerType.open:
        return 'O';
      case CAGEDFingerType.muted:
        return 'X';
    }
  }
}