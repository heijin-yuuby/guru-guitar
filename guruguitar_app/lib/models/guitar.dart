// 吉他相关数据模型
class GuitarString {
  final int stringNumber; // 1-6 (1为高音E弦)
  final String openNote;
  final int baseFret;

  const GuitarString({
    required this.stringNumber,
    required this.openNote,
    required this.baseFret,
  });
}

class FretPosition {
  final int stringNumber;
  final int fret;
  final String note;
  final String interval; // 在音阶中的度数

  const FretPosition({
    required this.stringNumber,
    required this.fret,
    required this.note,
    this.interval = '',
  });
}

class GuitarChord {
  final String name;
  final String rootNote;
  final String quality; // major, minor, dim, aug等
  final List<FretPosition> positions;
  final String fingering; // 指法字符串，如 "x32010"
  final int baseFret; // 起始品格
  final List<int> fingers; // 手指分配 [1,2,3,4] 对应食指到小指

  const GuitarChord({
    required this.name,
    required this.rootNote,
    required this.quality,
    required this.positions,
    required this.fingering,
    this.baseFret = 0,
    this.fingers = const [],
  });
}

class ScalePattern {
  final String name;
  final String rootNote;
  final String scaleType; // major, minor, dorian等
  final int position; // 把位 (1-12)
  final List<FretPosition> positions;
  final List<int> rootPositions; // 根音位置

  const ScalePattern({
    required this.name,
    required this.rootNote,
    required this.scaleType,
    required this.position,
    required this.positions,
    required this.rootPositions,
  });
}

class ChordProgression {
  final String name;
  final String key;
  final List<String> progression; // 如 ["I", "V", "vi", "IV"]
  final List<GuitarChord> chords;
  final String description;

  const ChordProgression({
    required this.name,
    required this.key,
    required this.progression,
    required this.chords,
    required this.description,
  });
}

// 吉他数据
class GuitarData {
  // 标准调弦 (从低音E到高音E)
  static const List<GuitarString> standardTuning = [
    GuitarString(stringNumber: 6, openNote: 'E', baseFret: 0),
    GuitarString(stringNumber: 5, openNote: 'A', baseFret: 5),
    GuitarString(stringNumber: 4, openNote: 'D', baseFret: 10),
    GuitarString(stringNumber: 3, openNote: 'G', baseFret: 15),
    GuitarString(stringNumber: 2, openNote: 'B', baseFret: 19),
    GuitarString(stringNumber: 1, openNote: 'E', baseFret: 24),
  ];

  // 音符循环表
  static const List<String> chromaticNotes = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  // 音程表
  static const Map<int, String> intervals = {
    0: '1', 1: 'b2', 2: '2', 3: 'b3', 4: '3', 5: '4',
    6: 'b5', 7: '5', 8: 'b6', 9: '6', 10: 'b7', 11: '7'
  };

  // 获取指定弦和品格的音符
  static String getNoteAtFret(int stringNumber, int fret) {
    final guitarString = standardTuning.firstWhere(
      (s) => s.stringNumber == stringNumber,
    );
    final openNoteIndex = chromaticNotes.indexOf(guitarString.openNote);
    final noteIndex = (openNoteIndex + fret) % 12;
    return chromaticNotes[noteIndex];
  }

  // 获取音阶在指板上的位置
  static List<FretPosition> getScalePositions(
    String rootNote,
    String scaleType,
    int startFret,
    int endFret,
  ) {
    final scaleIntervals = _getScaleIntervals(scaleType);
    final rootIndex = chromaticNotes.indexOf(rootNote);
    final scaleNotes = scaleIntervals.map((interval) => 
      chromaticNotes[(rootIndex + interval) % 12]
    ).toList();

    final positions = <FretPosition>[];

    for (final guitarString in standardTuning) {
      for (int fret = startFret; fret <= endFret; fret++) {
        final note = getNoteAtFret(guitarString.stringNumber, fret);
        if (scaleNotes.contains(note)) {
          final noteIndex = scaleNotes.indexOf(note);
          final intervalName = intervals[scaleIntervals[noteIndex]] ?? '';
          positions.add(FretPosition(
            stringNumber: guitarString.stringNumber,
            fret: fret,
            note: note,
            interval: intervalName,
          ));
        }
      }
    }

    return positions;
  }

  // 获取和弦形状
  static List<GuitarChord> getChordShapes(String rootNote, String quality) {
    final chordShapes = _basicChordShapes[quality] ?? [];
    return chordShapes.map((shape) => 
      _transposeChord(shape, rootNote)
    ).toList();
  }

  // 常见和弦进行
  static List<ChordProgression> getCommonProgressions(String key) {
    return _commonProgressions.where((p) => p.key == key).toList();
  }

  // 获取音阶音程
  static List<int> _getScaleIntervals(String scaleType) {
    switch (scaleType) {
      case 'major':
        return [0, 2, 4, 5, 7, 9, 11];
      case 'minor':
        return [0, 2, 3, 5, 7, 8, 10];
      case 'dorian':
        return [0, 2, 3, 5, 7, 9, 10];
      case 'mixolydian':
        return [0, 2, 4, 5, 7, 9, 10];
      case 'phrygian':
        return [0, 1, 3, 5, 7, 8, 10];
      case 'lydian':
        return [0, 2, 4, 6, 7, 9, 11];
      case 'locrian':
        return [0, 1, 3, 5, 6, 8, 10];
      default:
        return [0, 2, 4, 5, 7, 9, 11];
    }
  }

  // 移调和弦
  static GuitarChord _transposeChord(GuitarChord chord, String newRoot) {
    final originalRoot = chromaticNotes.indexOf(chord.rootNote);
    final newRootIndex = chromaticNotes.indexOf(newRoot);
    final semitones = (newRootIndex - originalRoot) % 12;

    final newPositions = chord.positions.map((pos) {
      final newFret = pos.fret + semitones;
      if (newFret >= 0 && newFret <= 24) {
        return FretPosition(
          stringNumber: pos.stringNumber,
          fret: newFret,
          note: getNoteAtFret(pos.stringNumber, newFret),
          interval: pos.interval,
        );
      }
      return pos;
    }).toList();

    return GuitarChord(
      name: chord.name.replaceFirst(chord.rootNote, newRoot),
      rootNote: newRoot,
      quality: chord.quality,
      positions: newPositions,
      fingering: chord.fingering,
      baseFret: chord.baseFret + semitones,
      fingers: chord.fingers,
    );
  }

  // 基础和弦形状 (以C为根音)
  static const Map<String, List<GuitarChord>> _basicChordShapes = {
    'major': [
      GuitarChord(
        name: 'C',
        rootNote: 'C',
        quality: 'major',
        positions: [
          FretPosition(stringNumber: 5, fret: 3, note: 'C'),
          FretPosition(stringNumber: 4, fret: 2, note: 'E'),
          FretPosition(stringNumber: 3, fret: 0, note: 'G'),
          FretPosition(stringNumber: 2, fret: 1, note: 'C'),
          FretPosition(stringNumber: 1, fret: 0, note: 'E'),
        ],
        fingering: 'x32010',
        fingers: [0, 3, 2, 0, 1, 0],
      ),
    ],
    'minor': [
      GuitarChord(
        name: 'Cm',
        rootNote: 'C',
        quality: 'minor',
        positions: [
          FretPosition(stringNumber: 5, fret: 3, note: 'C'),
          FretPosition(stringNumber: 4, fret: 1, note: 'Eb'),
          FretPosition(stringNumber: 3, fret: 0, note: 'G'),
          FretPosition(stringNumber: 2, fret: 1, note: 'C'),
          FretPosition(stringNumber: 1, fret: 3, note: 'G'),
        ],
        fingering: 'x31013',
        fingers: [0, 3, 1, 0, 1, 3],
      ),
    ],
  };

  // 常见和弦进行
  static const List<ChordProgression> _commonProgressions = [
    ChordProgression(
      name: 'vi-IV-I-V',
      key: 'C',
      progression: ['vi', 'IV', 'I', 'V'],
      chords: [], // 稍后实现
      description: 'Am-F-C-G 经典流行进行',
    ),
    ChordProgression(
      name: 'I-V-vi-IV',
      key: 'C',
      progression: ['I', 'V', 'vi', 'IV'],
      chords: [], // 稍后实现
      description: 'C-G-Am-F 流行摇滚进行',
    ),
  ];
}