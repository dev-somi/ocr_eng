import 'package:clickword/models/models.dart';
import 'package:clickword/providers/wordbook_provider.dart';
import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class WordBookDetailScreen extends ConsumerStatefulWidget {
  final String wordBookId;

  const WordBookDetailScreen({super.key, required this.wordBookId});

  @override
  ConsumerState<WordBookDetailScreen> createState() => _WordBookDetailScreenState();
}

class _WordBookDetailScreenState extends ConsumerState<WordBookDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final wordBooks = ref.watch(wordBookListProvider);
    final book = wordBooks.firstWhere(
          (b) => b.id == widget.wordBookId,
      orElse: () => WordBook.create(title: "Not Found"),
    );

    if (book.title == "Not Found") {
      return const Scaffold(
        body: Center(child: Text("단어장을 찾을 수 없어요")),
      );
    }

    return Scaffold(
      backgroundColor: LightColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.camera),
        icon: const Icon(Icons.add_a_photo_rounded, color: LightColors.onPrimary),
        label: const Text("새 단어 스캔"),
        backgroundColor: LightColors.primary,
        foregroundColor: LightColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton(Icons.arrow_back_rounded, () => context.pop()),
                  _buildNavButton(Icons.edit_rounded, () {
                    // Edit wordbook
                  }, color: LightColors.secondary),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: LightColors.success,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Text(
                          "Unit 4",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: LightColors.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        "${book.words.length}개 단어",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: LightColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: LightColors.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      "플래시카드",
                      Icons.style_rounded,
                      const Color(0xFF4CC9F0),
                      const Color(0xFF0077B6),
                          () => context.push(AppRoutes.flashcard, extra: book.id),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      "퀴즈",
                      Icons.extension_rounded,
                      const Color(0xFFFFD166),
                      const Color(0xFFB29400),
                          () => context.push(AppRoutes.quiz, extra: book.id),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      "말하기",
                      Icons.record_voice_over_rounded,
                      const Color(0xFF52B788),
                      const Color(0xFF2D6A4F),
                          () {}, // TODO: Implement Speak mode
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "단어 목록",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: LightColors.primaryText,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: LightColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: LightColors.divider, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort_rounded, color: LightColors.secondaryText, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          "A-Z",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: LightColors.secondaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (book.words.isEmpty)
                const Center(child: Text("아직 단어가 없어요.")),
              ...book.words.map((word) => _buildWordItem(context, word)).toList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap, {Color color = LightColors.surface}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String label,
      IconData icon,
      Color bg,
      Color borderColor,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: LightColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Icon(icon, color: borderColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: borderColor, // Using border color for text contrast on colored bg
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordItem(BuildContext context, Word word) {
    // Calculate accuracy mock
    final total = word.correctCount + word.wrongCount;
    final accuracy = total == 0 ? "신규" : "${((word.correctCount / total) * 100).toInt()}%";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LightColors.divider, width: 3),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _speak(word.english),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.volume_up_rounded, color: LightColors.primary, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.english,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: LightColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  word.korean,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: LightColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9DB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD60A), width: 2),
            ),
            child: Text(
              accuracy,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFFB29400),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
