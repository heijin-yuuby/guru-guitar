class MusicKey {
  final String name;
  final String note;
  final List<String> scale;
  final List<String> chords;
  final int sharps;
  final int flats;
  final double angle; // 在五度圈中的角度位置

  const MusicKey({
    required this.name,
    required this.note,
    required this.scale,
    required this.chords,
    required this.sharps,
    required this.flats,
    required this.angle,
  });
}

class ScaleNote {
  final String note;
  final String degree;
  final String degreeName;
  final int fret; // 在吉他指板上的位置

  const ScaleNote({
    required this.note,
    required this.degree,
    required this.degreeName,
    required this.fret,
  });
}

class Chord {
  final String name;
  final String type;
  final List<String> notes;
  final String fingering; // 指法描述

  const Chord({
    required this.name,
    required this.type,
    required this.notes,
    required this.fingering,
  });
}

class MusicTheory {
  static const List<MusicKey> circleOfFifths = [
    // 五度圈标准排列：C在顶部，顺时针增加升号，逆时针增加降号
    MusicKey(
      name: 'C大调',
      note: 'C',
      scale: ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
      chords: ['C', 'Dm', 'Em', 'F', 'G', 'Am', 'Bdim'],
      sharps: 0,
      flats: 0,
      angle: 0, // 顶部位置
    ),
    MusicKey(
      name: 'G大调',
      note: 'G',
      scale: ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
      chords: ['G', 'Am', 'Bm', 'C', 'D', 'Em', 'F#dim'],
      sharps: 1,
      flats: 0,
      angle: 30,
    ),
    MusicKey(
      name: 'D大调',
      note: 'D',
      scale: ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
      chords: ['D', 'Em', 'F#m', 'G', 'A', 'Bm', 'C#dim'],
      sharps: 2,
      flats: 0,
      angle: 60,
    ),
    MusicKey(
      name: 'A大调',
      note: 'A',
      scale: ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
      chords: ['A', 'Bm', 'C#m', 'D', 'E', 'F#m', 'G#dim'],
      sharps: 3,
      flats: 0,
      angle: 90,
    ),
    MusicKey(
      name: 'E大调',
      note: 'E',
      scale: ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
      chords: ['E', 'F#m', 'G#m', 'A', 'B', 'C#m', 'D#dim'],
      sharps: 4,
      flats: 0,
      angle: 120,
    ),
    MusicKey(
      name: 'B大调',
      note: 'B',
      scale: ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A#'],
      chords: ['B', 'C#m', 'D#m', 'E', 'F#', 'G#m', 'A#dim'],
      sharps: 5,
      flats: 0,
      angle: 150,
    ),
    MusicKey(
      name: 'F#大调',
      note: 'F#',
      scale: ['F#', 'G#', 'A#', 'B', 'C#', 'D#', 'E#'],
      chords: ['F#', 'G#m', 'A#m', 'B', 'C#', 'D#m', 'E#dim'],
      sharps: 6,
      flats: 0,
      angle: 180,
    ),
    MusicKey(
      name: 'C#大调',
      note: 'C#',
      scale: ['C#', 'D#', 'E#', 'F#', 'G#', 'A#', 'B#'],
      chords: ['C#', 'D#m', 'E#m', 'F#', 'G#', 'A#m', 'B#dim'],
      sharps: 7,
      flats: 0,
      angle: 210,
    ),
    // 逆时针方向：F, Bb, Eb, Ab, Db, Gb, Cb
    MusicKey(
      name: 'F大调',
      note: 'F',
      scale: ['F', 'G', 'A', 'Bb', 'C', 'D', 'E'],
      chords: ['F', 'Gm', 'Am', 'Bb', 'C', 'Dm', 'Edim'],
      sharps: 0,
      flats: 1,
      angle: 330,
    ),
    MusicKey(
      name: 'Bb大调',
      note: 'Bb',
      scale: ['Bb', 'C', 'D', 'Eb', 'F', 'G', 'A'],
      chords: ['Bb', 'Cm', 'Dm', 'Eb', 'F', 'Gm', 'Adim'],
      sharps: 0,
      flats: 2,
      angle: 300,
    ),
    MusicKey(
      name: 'Eb大调',
      note: 'Eb',
      scale: ['Eb', 'F', 'G', 'Ab', 'Bb', 'C', 'D'],
      chords: ['Eb', 'Fm', 'Gm', 'Ab', 'Bb', 'Cm', 'Ddim'],
      sharps: 0,
      flats: 3,
      angle: 270,
    ),
    MusicKey(
      name: 'Ab大调',
      note: 'Ab',
      scale: ['Ab', 'Bb', 'C', 'Db', 'Eb', 'F', 'G'],
      chords: ['Ab', 'Bbm', 'Cm', 'Db', 'Eb', 'Fm', 'Gdim'],
      sharps: 0,
      flats: 4,
      angle: 240,
    ),
    // 添加更多调性以完成完整的五度圈
    MusicKey(
      name: 'Db大调',
      note: 'Db',
      scale: ['Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb', 'C'],
      chords: ['Db', 'Ebm', 'Fm', 'Gb', 'Ab', 'Bbm', 'Cdim'],
      sharps: 0,
      flats: 5,
      angle: 210,
    ),
    MusicKey(
      name: 'Gb大调',
      note: 'Gb',
      scale: ['Gb', 'Ab', 'Bb', 'Cb', 'Db', 'Eb', 'F'],
      chords: ['Gb', 'Abm', 'Bbm', 'Cb', 'Db', 'Ebm', 'Fdim'],
      sharps: 0,
      flats: 6,
      angle: 180,
    ),
  ];

  static const Map<String, List<ScaleNote>> scaleNotes = {
    'C': [
      ScaleNote(note: 'C', degree: '1', degreeName: '主音', fret: 0),
      ScaleNote(note: 'D', degree: '2', degreeName: '上主音', fret: 2),
      ScaleNote(note: 'E', degree: '3', degreeName: '中音', fret: 4),
      ScaleNote(note: 'F', degree: '4', degreeName: '下属音', fret: 5),
      ScaleNote(note: 'G', degree: '5', degreeName: '属音', fret: 7),
      ScaleNote(note: 'A', degree: '6', degreeName: '下中音', fret: 9),
      ScaleNote(note: 'B', degree: '7', degreeName: '导音', fret: 11),
    ],
    'G': [
      ScaleNote(note: 'G', degree: '1', degreeName: '主音', fret: 0),
      ScaleNote(note: 'A', degree: '2', degreeName: '上主音', fret: 2),
      ScaleNote(note: 'B', degree: '3', degreeName: '中音', fret: 4),
      ScaleNote(note: 'C', degree: '4', degreeName: '下属音', fret: 5),
      ScaleNote(note: 'D', degree: '5', degreeName: '属音', fret: 7),
      ScaleNote(note: 'E', degree: '6', degreeName: '下中音', fret: 9),
      ScaleNote(note: 'F#', degree: '7', degreeName: '导音', fret: 11),
    ],
  };

  // 大三和弦的组成音模式（根音、三度、五度） - 使用正确的音名表示
  static const Map<String, List<String>> majorChordNotes = {
    // 升号调和弦
    'C': ['C', 'E', 'G'],
    'G': ['G', 'B', 'D'],
    'D': ['D', 'F#', 'A'],
    'A': ['A', 'C#', 'E'],
    'E': ['E', 'G#', 'B'],
    'B': ['B', 'D#', 'F#'],
    'F#': ['F#', 'A#', 'C#'],
    'C#': ['C#', 'E#', 'G#'],
    
    // 降号调和弦
    'F': ['F', 'A', 'C'],
    'Bb': ['Bb', 'D', 'F'],
    'Eb': ['Eb', 'G', 'Bb'],
    'Ab': ['Ab', 'C', 'Eb'],
    'Db': ['Db', 'F', 'Ab'],
    'Gb': ['Gb', 'Bb', 'Db'],
    'Cb': ['Cb', 'Eb', 'Gb'],
    
    // 等音关系的备选名称
    'D#': ['D#', 'G', 'A#'],
    'G#': ['G#', 'C', 'D#'],
    'A#': ['A#', 'D', 'F'],
  };

  // 小三和弦的组成音模式（根音、小三度、五度） - 使用正确的音名表示
  static const Map<String, List<String>> minorChordNotes = {
    // 升号调小调和弦
    'A': ['A', 'C', 'E'],
    'E': ['E', 'G', 'B'],
    'B': ['B', 'D', 'F#'],
    'F#': ['F#', 'A', 'C#'],
    'C#': ['C#', 'E', 'G#'],
    'G#': ['G#', 'B', 'D#'],
    'D#': ['D#', 'F#', 'A#'],
    'A#': ['A#', 'C#', 'E#'],
    
    // 降号调小调和弦
    'D': ['D', 'F', 'A'],
    'G': ['G', 'Bb', 'D'],
    'C': ['C', 'Eb', 'G'],
    'F': ['F', 'Ab', 'C'],
    'Bb': ['Bb', 'Db', 'F'],
    'Eb': ['Eb', 'Gb', 'Bb'],
    'Ab': ['Ab', 'Cb', 'Eb'],
  };

  static const Map<String, List<Chord>> commonChords = {
    'C': [
      Chord(name: 'C', type: '大三和弦', notes: ['C', 'E', 'G'], fingering: 'x32010'),
      Chord(name: 'F', type: '大三和弦', notes: ['F', 'A', 'C'], fingering: '133211'),
      Chord(name: 'G', type: '大三和弦', notes: ['G', 'B', 'D'], fingering: '320003'),
    ],
    'G': [
      Chord(name: 'G', type: '大三和弦', notes: ['G', 'B', 'D'], fingering: '320003'),
      Chord(name: 'C', type: '大三和弦', notes: ['C', 'E', 'G'], fingering: 'x32010'),
      Chord(name: 'D', type: '大三和弦', notes: ['D', 'F#', 'A'], fingering: 'xx0232'),
    ],
  };

  static MusicKey? getKeyByNote(String note) {
    try {
      return circleOfFifths.firstWhere((key) => key.note == note);
    } catch (e) {
      return null;
    }
  }

  static List<ScaleNote> getScaleNotes(String key) {
    return scaleNotes[key] ?? [];
  }

  static List<Chord> getCommonChords(String key) {
    return commonChords[key] ?? [];
  }
} 