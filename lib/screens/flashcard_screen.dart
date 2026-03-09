import 'dart:math';

import 'package:clickword/models/models.dart';
import 'package:clickword/providers/wordbook_provider.dart';
import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final String wordBookId;

  const FlashcardScreen({super.key, required this.wordBookId});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;
  bool _isFront = true;
  final FlutterTts _flutterTts = FlutterTts();
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
      // Auto-play TTS on flip to back? Maybe configurable.
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _nextCard(bool known) {
    // Record result
    final word = _words[_currentIndex];
    // In a real app, we would save StudyLog here

    // Move to next
    if (_currentIndex < _words.length - 1) {
      // Reset flip
      if (!_isFront) {
        _controller.reset();
        setState(() {
          _isFront = true;
        });
      }

      setState(() {
        _currentIndex++;
      });
    } else {
      // Finish
      context.pop(); // Or go to results
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordBooks = ref.watch(wordBookListProvider);
    final book = wordBooks.firstWhere(
          (b) => b.id == widget.wordBookId,
      orElse: () => WordBook.create(title: "Not Found"),
    );

    if (book.title == "Not Found") return const Scaffold(body: Center(child: Text("Not Found")));
    if (_words.isEmpty && book.words.isNotEmpty) {
      _words = List.from(book.words);
    }

    if (_words.isEmpty) return const Scaffold(body: Center(child: Text("No words")));

    final word = _words[_currentIndex];

    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(Icons.close_rounded, () => context.pop()),
                  Column(
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: LightColors.primaryText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                            min(5, _words.length),
                                (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == _currentIndex % 5 ? LightColors.primary : LightColors.divider.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  _buildTopButton(Icons.volume_up_rounded, () => _flutterTts.speak(word.english)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final angle = _animation.value * pi;
                      final isBack = angle >= pi / 2;
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle);

                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: isBack
                            ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: _buildCardBack(word),
                        )
                            : _buildCardFront(word),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionPill(
                      context,
                      "Again",
                      Icons.sentiment_very_dissatisfied_rounded,
                      LightColors.error,
                          () => _nextCard(false),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildActionPill(
                      context,
                      "Got it!",
                      Icons.sentiment_very_satisfied_rounded,
                      LightColors.success,
                          () => _nextCard(true),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Card ${_currentIndex + 1} of ${_words.length}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: LightColors.secondaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Nav buttons
                  Row(
                    children: [
                      IconButton(
                        onPressed: _currentIndex > 0 ? () => setState(() => _currentIndex--) : null,
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                      ),
                      IconButton(
                        onPressed: _currentIndex < _words.length - 1 ? () => setState(() => _currentIndex++) : null,
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(Word word) {
    return Container(
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 8),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: const Icon(Icons.image, size: 64, color: Colors.black), // Placeholder for image
          ),
          const SizedBox(height: 32),
          Text(
            word.english,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: LightColors.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 42,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 3, indent: 40, endIndent: 40, color: LightColors.divider),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: LightColors.divider, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sync_rounded, color: LightColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Tap to see meaning",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: LightColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Word word) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // Different bg for back
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 8),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          word.korean,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: LightColors.primaryText,
            fontWeight: FontWeight.w900,
            fontSize: 42,
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: LightColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildActionPill(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: LightColors.onPrimary, size: 28),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: LightColors.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
