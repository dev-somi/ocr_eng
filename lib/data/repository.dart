import 'package:clickword/models/adapters.dart';
import 'package:clickword/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final repositoryProvider = Provider<WordRepository>((ref) => WordRepository());

class WordRepository {
  static const String wordBookBoxName = 'wordbooks';
  static const String studyLogBoxName = 'studylogs';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WordBookAdapter());
    Hive.registerAdapter(WordAdapter());
    Hive.registerAdapter(StudyLogAdapter());

    await Hive.openBox<WordBook>(wordBookBoxName);
    await Hive.openBox<StudyLog>(studyLogBoxName);
  }

  Box<WordBook> get _wordBookBox => Hive.box<WordBook>(wordBookBoxName);
  Box<StudyLog> get _studyLogBox => Hive.box<StudyLog>(studyLogBoxName);

  List<WordBook> getWordBooks() {
    return _wordBookBox.values.toList();
  }

  Future<void> addWordBook(WordBook book) async {
    await _wordBookBox.put(book.id, book);
  }

  Future<void> updateWordBook(WordBook book) async {
    await book.save();
  }

  Future<void> deleteWordBook(String id) async {
    await _wordBookBox.delete(id);
  }

  WordBook? getWordBook(String id) {
    return _wordBookBox.get(id);
  }

  Future<void> addStudyLog(StudyLog log) async {
    await _studyLogBox.put(log.id, log);
  }

  List<StudyLog> getStudyLogs() {
    return _studyLogBox.values.toList();
  }

  // Seed data for demo
  Future<void> seedData() async {
    if (_wordBookBox.isEmpty) {
      final book1 = WordBook.create(
        title: "Chapter 5: Animals",
        iconName: "pets_rounded",
        colorValue: 0xFF4CC9F0,
      );
      book1.words = [
        Word.create(english: "Elephant", korean: "코끼리"),
        Word.create(english: "Tiger", korean: "호랑이"),
        Word.create(english: "Giraffe", korean: "기린"),
        Word.create(english: "Monkey", korean: "원숭이"),
        Word.create(english: "Lion", korean: "사자"),
      ];

      final book2 = WordBook.create(
        title: "Weekly Test #12",
        iconName: "description_rounded",
        colorValue: 0xFFFFD166,
      );
      book2.words = [
        Word.create(english: "School", korean: "학교"),
        Word.create(english: "Teacher", korean: "선생님"),
        Word.create(english: "Student", korean: "학생"),
        Word.create(english: "Book", korean: "책"),
      ];

      await addWordBook(book1);
      await addWordBook(book2);
    }
  }
}
