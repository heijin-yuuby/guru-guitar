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

  // C形状和弦 - 全指板位置
  static CAGEDChord _getCShape(String rootNote, int rootIndex) {
    List<CAGEDPosition> allPositions = [];
    
    // C形状的相对位置模式 (相对于根音位置)
    List<Map<String, dynamic>> pattern = [
      {'string': 5, 'fretOffset': 3, 'type': CAGEDFingerType.root, 'isRoot': true},
      {'string': 4, 'fretOffset': 2, 'type': CAGEDFingerType.fifth, 'isRoot': false},
      {'string': 3, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': false},
      {'string': 2, 'fretOffset': 1, 'type': CAGEDFingerType.third, 'isRoot': false},
      {'string': 1, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': false},
    ];
    
    // 计算在整个指板上的所有位置 (0-15品)
    for (int baseFret = 0; baseFret <= 15; baseFret++) {
      // 检查这个位置是否与根音匹配
      int rootFretOnString5 = (baseFret + 3) % 12;
      if (rootFretOnString5 == rootIndex) {
        for (var pos in pattern) {
          int actualFret = baseFret + (pos['fretOffset'] as int);
          if (actualFret >= 0 && actualFret <= 15) {
            allPositions.add(CAGEDPosition(
              string: pos['string'] as int,
              fret: actualFret,
              type: pos['type'] as CAGEDFingerType,
              isRoot: pos['isRoot'] as bool,
            ));
          }
        }
      }
    }
    
    return CAGEDChord(
      name: 'C形状',
      description: '基于C和弦的指型，全指板位置',
      baseFret: 0, // 不再使用单一基准品格
      positions: allPositions,
    );
  }

  // A形状和弦 - 全指板位置
  static CAGEDChord _getAShape(String rootNote, int rootIndex) {
    List<CAGEDPosition> allPositions = [];
    
    // A形状的相对位置模式 (横按指型)
    List<Map<String, dynamic>> pattern = [
      {'string': 5, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': true},
      {'string': 4, 'fretOffset': 2, 'type': CAGEDFingerType.fifth, 'isRoot': false},
      {'string': 3, 'fretOffset': 2, 'type': CAGEDFingerType.third, 'isRoot': false},
      {'string': 2, 'fretOffset': 2, 'type': CAGEDFingerType.root, 'isRoot': false},
      {'string': 1, 'fretOffset': 0, 'type': CAGEDFingerType.fifth, 'isRoot': false},
    ];
    
    // 计算在整个指板上的所有位置
    for (int baseFret = 0; baseFret <= 15; baseFret++) {
      // 检查5弦上的根音位置
      int rootFretOnString5 = baseFret % 12;
      if (rootFretOnString5 == rootIndex) {
        for (var pos in pattern) {
          int actualFret = baseFret + (pos['fretOffset'] as int);
          if (actualFret >= 0 && actualFret <= 15) {
            allPositions.add(CAGEDPosition(
              string: pos['string'] as int,
              fret: actualFret,
              type: pos['type'] as CAGEDFingerType,
              isRoot: pos['isRoot'] as bool,
            ));
          }
        }
      }
    }
    
    return CAGEDChord(
      name: 'A形状',
      description: '基于A和弦的横按指型，全指板位置',
      baseFret: 0,
      positions: allPositions,
    );
  }

  // G形状和弦 - 全指板位置
  static CAGEDChord _getGShape(String rootNote, int rootIndex) {
    List<CAGEDPosition> allPositions = [];
    
    // G形状的相对位置模式
    List<Map<String, dynamic>> pattern = [
      {'string': 6, 'fretOffset': 3, 'type': CAGEDFingerType.root, 'isRoot': true},
      {'string': 5, 'fretOffset': 2, 'type': CAGEDFingerType.fifth, 'isRoot': false},
      {'string': 4, 'fretOffset': 0, 'type': CAGEDFingerType.third, 'isRoot': false},
      {'string': 3, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': false},
      {'string': 1, 'fretOffset': 3, 'type': CAGEDFingerType.root, 'isRoot': false},
    ];
    
    // 计算在整个指板上的所有位置
    for (int baseFret = 0; baseFret <= 12; baseFret++) { // G形状最高到12品
      // 检查6弦上的根音位置（加3品后）
      int rootFretOnString6 = (baseFret + 3) % 12;
      if (rootFretOnString6 == rootIndex) {
        for (var pos in pattern) {
          int actualFret = baseFret + (pos['fretOffset'] as int);
          if (actualFret >= 0 && actualFret <= 15) {
            allPositions.add(CAGEDPosition(
              string: pos['string'] as int,
              fret: actualFret,
              type: pos['type'] as CAGEDFingerType,
              isRoot: pos['isRoot'] as bool,
            ));
          }
        }
      }
    }
    
    return CAGEDChord(
      name: 'G形状',
      description: '基于G和弦的指型，全指板位置',
      baseFret: 0,
      positions: allPositions,
    );
  }

  // E形状和弦 - 全指板位置
  static CAGEDChord _getEShape(String rootNote, int rootIndex) {
    List<CAGEDPosition> allPositions = [];
    
    // E形状的相对位置模式 (横按指型)
    List<Map<String, dynamic>> pattern = [
      {'string': 6, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': true},
      {'string': 5, 'fretOffset': 2, 'type': CAGEDFingerType.fifth, 'isRoot': false},
      {'string': 4, 'fretOffset': 2, 'type': CAGEDFingerType.root, 'isRoot': false},
      {'string': 3, 'fretOffset': 1, 'type': CAGEDFingerType.third, 'isRoot': false},
      {'string': 2, 'fretOffset': 0, 'type': CAGEDFingerType.fifth, 'isRoot': false},
      {'string': 1, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': false},
    ];
    
    // 计算在整个指板上的所有位置
    for (int baseFret = 0; baseFret <= 15; baseFret++) {
      // 检查6弦上的根音位置
      int rootFretOnString6 = baseFret % 12;
      if (rootFretOnString6 == rootIndex) {
        for (var pos in pattern) {
          int actualFret = baseFret + (pos['fretOffset'] as int);
          if (actualFret >= 0 && actualFret <= 15) {
            allPositions.add(CAGEDPosition(
              string: pos['string'] as int,
              fret: actualFret,
              type: pos['type'] as CAGEDFingerType,
              isRoot: pos['isRoot'] as bool,
            ));
          }
        }
      }
    }
    
    return CAGEDChord(
      name: 'E形状',
      description: '基于E和弦的横按指型，全指板位置',
      baseFret: 0,
      positions: allPositions,
    );
  }

  // D形状和弦 - 全指板位置
  static CAGEDChord _getDShape(String rootNote, int rootIndex) {
    List<CAGEDPosition> allPositions = [];
    
    // D形状的相对位置模式
    List<Map<String, dynamic>> pattern = [
      {'string': 4, 'fretOffset': 0, 'type': CAGEDFingerType.root, 'isRoot': true},
      {'string': 3, 'fretOffset': 2, 'type': CAGEDFingerType.fifth, 'isRoot': false},
      {'string': 2, 'fretOffset': 3, 'type': CAGEDFingerType.root, 'isRoot': false},
      {'string': 1, 'fretOffset': 2, 'type': CAGEDFingerType.third, 'isRoot': false},
    ];
    
    // 计算在整个指板上的所有位置
    for (int baseFret = 0; baseFret <= 12; baseFret++) { // D形状最高到12品
      // 检查4弦上的根音位置
      int rootFretOnString4 = baseFret % 12;
      if (rootFretOnString4 == rootIndex) {
        for (var pos in pattern) {
          int actualFret = baseFret + (pos['fretOffset'] as int);
          if (actualFret >= 0 && actualFret <= 15) {
            allPositions.add(CAGEDPosition(
              string: pos['string'] as int,
              fret: actualFret,
              type: pos['type'] as CAGEDFingerType,
              isRoot: pos['isRoot'] as bool,
            ));
          }
        }
      }
    }
    
    return CAGEDChord(
      name: 'D形状',
      description: '基于D和弦的指型，全指板位置',
      baseFret: 0,
      positions: allPositions,
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