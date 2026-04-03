import 'dart:math';

import 'package:clickword/models/models.dart';
import 'package:clickword/providers/wordbook_provider.dart';
import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String wordBookId;

  const QuizScreen({super.key, required this.wordBookId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  List<Word> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  List<String> _options = [];
  String? _selectedOption;
  bool _answered = false;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
  }

  void _generateOptions() {
    if (_questions.isEmpty) return;

    final currentWord = _questions[_currentIndex];
    final allWords = ref.read(wordBookListProvider)
        .firstWhere((b) => b.id == widget.wordBookId)
        .words;

    final distractors = allWords
        .where((w) => w.id != currentWord.id)
        .map((w) => w.korean)
        .toList();

    distractors.shuffle();
    final wrongAnswers = distractors.take(3).toList();

    // Fill with dummy if not enough words
    while (wrongAnswers.length < 3) {
      wrongAnswers.add("Dummy Meaning ${wrongAnswers.length}");
    }

    _options = [currentWord.korean, ...wrongAnswers];
    _options.shuffle();
  }

  void _checkAnswer() {
    if (_selectedOption == null) return;

    final currentWord = _questions[_currentIndex];
    final isCorrect = _selectedOption == currentWord.korean;

    setState(() {
      _answered = true;
      if (isCorrect) _score += 100;
    });

    // Play sound or feedback
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedOption = null;
        _generateOptions();
      });
    } else {
      context.replace(AppRoutes.quizResult, extra: {
        'score': _score,
        'total': _questions.length * 100,
        'correctCount': _score ~/ 100, // Approximate
        'totalCount': _questions.length,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordBooks = ref.watch(wordBookListProvider);
    final book = wordBooks.firstWhere(
          (b) => b.id == widget.wordBookId,
      orElse: () => WordBook.create(title: "Not Found"),
    );

    if (book.title == "Not Found") return const Scaffold(body: Center(child: Text("찾을 수 없음")));

    if (_questions.isEmpty && book.words.isNotEmpty) {
      _questions = List.from(book.words)..shuffle();
      _generateOptions();
    }

    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text("퀴즈할 단어가 없어요")));

    final currentWord = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(Icons.close_rounded, () => context.pop()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (_currentIndex + 1) / _questions.length,
                          child: Container(color: LightColors.success),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: LightColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB59800), width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Color(0xFFB59800), size: 20),
                        const SizedBox(width: 4),
                        Text(
                          "$_score",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: const Color(0xFFB59800),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Question Card
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: LightColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: LightColors.divider, width: 3),
                  boxShadow: const [AppShadows.md],
                ),
                child: Column(
                  children: [
                    Text(
                      "다음 단어의 뜻은?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LightColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentWord.english,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: LightColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _flutterTts.speak(currentWord.english),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: LightColors.background,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(color: LightColors.divider, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up_rounded, color: LightColors.primary, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "듣기",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: LightColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected = _selectedOption == option;
                      final label = String.fromCharCode(65 + index); // A, B, C, D

                      Color borderColor = LightColors.divider;
                      Color bgColor = LightColors.surface;

                      if (_answered) {
                        if (option == currentWord.korean) {
                          borderColor = LightColors.success;
                          bgColor = LightColors.success.withOpacity(0.1);
                        } else if (isSelected) {
                          borderColor = LightColors.error;
                          bgColor = LightColors.error.withOpacity(0.1);
                        }
                      } else if (isSelected) {
                        borderColor = LightColors.primary;
                        bgColor = LightColors.primary.withOpacity(0.1);
                      }

                      return GestureDetector(
                        onTap: _answered ? null : () => setState(() => _selectedOption = option),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderColor, width: 3),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected ? LightColors.primary : LightColors.background,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? LightColors.primary : LightColors.divider, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: isSelected ? LightColors.onPrimary : LightColors.primaryText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  option,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: LightColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Bottom Action
              if (!_answered)
                GestureDetector(
                  onTap: _checkAnswer,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: LightColors.success,
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF3D8B68), width: 5),
                        top: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "정답 확인",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: LightColors.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: _nextQuestion,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: LightColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFC42B36), width: 5),
                        top: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _currentIndex < _questions.length - 1 ? "다음 문제" : "결과 보기",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: LightColors.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: LightColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LightColors.divider, width: 2),
        ),
        child: Icon(icon, color: LightColors.primaryText, size: 24),
      ),
    );
  }
}
