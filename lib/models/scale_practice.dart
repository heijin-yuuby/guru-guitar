enum PracticeMode {
  majorScale,
  minorScale,
  memoryTest,
  dorianMode,
  mixolydianMode,
  phrygianMode,
  lydianMode,
  locrianMode,
}

class ScalePractice {
  final String key;
  final PracticeMode mode;
  final List<String> notes;
  final String description;

  const ScalePractice({
    required this.key,
    required this.mode,
    required this.notes,
    required this.description,
  });
}

class PracticeSession {
  final String key;
  final PracticeMode mode;
  final List<String> correctNotes;
  final List<String> userNotes;
  final int score;
  final DateTime timestamp;

  const PracticeSession({
    required this.key,
    required this.mode,
    required this.correctNotes,
    required this.userNotes,
    required this.score,
    required this.timestamp,
  });
}

class ScalePracticeData {
  static const Map<String, Map<PracticeMode, ScalePractice>> practiceData = {
    'C': {
      PracticeMode.majorScale: ScalePractice(
        key: 'C',
        mode: PracticeMode.majorScale,
        notes: ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
        description: 'C大调音阶',
      ),
      PracticeMode.minorScale: ScalePractice(
        key: 'C',
        mode: PracticeMode.minorScale,
        notes: ['C', 'D', 'Eb', 'F', 'G', 'Ab', 'Bb'],
        description: 'C小调音阶',
      ),
      PracticeMode.dorianMode: ScalePractice(
        key: 'C',
        mode: PracticeMode.dorianMode,
        notes: ['C', 'D', 'Eb', 'F', 'G', 'A', 'Bb'],
        description: 'C多利安调式',
      ),
      PracticeMode.mixolydianMode: ScalePractice(
        key: 'C',
        mode: PracticeMode.mixolydianMode,
        notes: ['C', 'D', 'E', 'F', 'G', 'A', 'Bb'],
        description: 'C混合利底亚调式',
      ),
      PracticeMode.phrygianMode: ScalePractice(
        key: 'C',
        mode: PracticeMode.phrygianMode,
        notes: ['C', 'Db', 'Eb', 'F', 'G', 'Ab', 'Bb'],
        description: 'C弗里吉亚调式',
      ),
      PracticeMode.lydianMode: ScalePractice(
        key: 'C',
        mode: PracticeMode.lydianMode,
        notes: ['C', 'D', 'E', 'F#', 'G', 'A', 'B'],
        description: 'C利底亚调式',
      ),
      PracticeMode.locrianMode: ScalePractice(
        key: 'C',
        mode: PracticeMode.locrianMode,
        notes: ['C', 'Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb'],
        description: 'C洛克里亚调式',
      ),
    },
    'G': {
      PracticeMode.majorScale: ScalePractice(
        key: 'G',
        mode: PracticeMode.majorScale,
        notes: ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
        description: 'G大调音阶',
      ),
      PracticeMode.minorScale: ScalePractice(
        key: 'G',
        mode: PracticeMode.minorScale,
        notes: ['G', 'A', 'Bb', 'C', 'D', 'Eb', 'F'],
        description: 'G小调音阶',
      ),
      PracticeMode.dorianMode: ScalePractice(
        key: 'G',
        mode: PracticeMode.dorianMode,
        notes: ['G', 'A', 'Bb', 'C', 'D', 'E', 'F'],
        description: 'G多利安调式',
      ),
      PracticeMode.mixolydianMode: ScalePractice(
        key: 'G',
        mode: PracticeMode.mixolydianMode,
        notes: ['G', 'A', 'B', 'C', 'D', 'E', 'F'],
        description: 'G混合利底亚调式',
      ),
    },
  };

  static List<String> getRandomizedNotes(String key, PracticeMode mode) {
    final practice = practiceData[key]?[mode];
    if (practice == null) return [];
    
    final notes = List<String>.from(practice.notes);
    notes.shuffle();
    return notes;
  }

  static ScalePractice? getPractice(String key, PracticeMode mode) {
    return practiceData[key]?[mode];
  }

  static List<PracticeMode> getAvailableModes(String key) {
    return practiceData[key]?.keys.toList() ?? [];
  }

  static int calculateScore(List<String> correct, List<String> user) {
    if (correct.length != user.length) return 0;
    
    int score = 0;
    for (int i = 0; i < correct.length; i++) {
      if (correct[i] == user[i]) {
        score += 100 ~/ correct.length;
      }
    }
    return score;
  }
} 