import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class WordBook extends HiveObject {
  final String id;
  String title;
  final DateTime createdAt;
  List<Word> words;
  String iconName; // For UI display
  int colorValue; // For UI display

  WordBook({
    required this.id,
    required this.title,
    required this.createdAt,
    this.words = const [],
    this.iconName = 'book',
    this.colorValue = 0xFF4CC9F0,
  });

  // Custom factory for creating new instances
  factory WordBook.create({required String title, String iconName = 'book', int colorValue = 0xFF4CC9F0}) {
    return WordBook(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      words: [],
      iconName: iconName,
      colorValue: colorValue,
    );
  }
}

class Word extends HiveObject {
  final String id;
  final String english;
  String korean;
  int correctCount;
  int wrongCount;
  DateTime? lastStudied;

  Word({
    required this.id,
    required this.english,
    required this.korean,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.lastStudied,
  });

  factory Word.create({required String english, required String korean}) {
    return Word(
      id: const Uuid().v4(),
      english: english,
      korean: korean,
    );
  }
}

class StudyLog extends HiveObject {
  final String id;
  final String wordId;
  final bool isCorrect;
  final String studyMode;
  final DateTime timestamp;

  StudyLog({
    required this.id,
    required this.wordId,
    required this.isCorrect,
    required this.studyMode,
    required this.timestamp,
  });

  factory StudyLog.create({
    required String wordId,
    required bool isCorrect,
    required String studyMode,
  }) {
    return StudyLog(
      id: const Uuid().v4(),
      wordId: wordId,
      isCorrect: isCorrect,
      studyMode: studyMode,
      timestamp: DateTime.now(),
    );
  }
}
