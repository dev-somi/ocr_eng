import 'dart:io';

import 'package:clickword/models/models.dart';
import 'package:clickword/providers/wordbook_provider.dart';
import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class WordSelectionScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const WordSelectionScreen({super.key, required this.imagePath});

  @override
  ConsumerState<WordSelectionScreen> createState() => _WordSelectionScreenState();
}

class _WordSelectionScreenState extends ConsumerState<WordSelectionScreen> {
  final _latinRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _koreanRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
  bool _isProcessing = true;
  List<Word> _extractedWords = [];
  final Set<String> _selectedWordIds = {};

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  @override
  void dispose() {
    _latinRecognizer.close();
    _koreanRecognizer.close();
    super.dispose();
  }

  Future<void> _processImage() async {
    try {
      final inputImage = InputImage.fromFilePath(widget.imagePath);

      // 영어, 한국어 OCR 동시 실행
      final results = await Future.wait([
        _latinRecognizer.processImage(inputImage),
        _koreanRecognizer.processImage(inputImage),
      ]);
      final latinResult = results[0];
      final koreanResult = results[1];

      // 영어 줄 추출: {centerY → english text}
      final Map<double, String> englishByY = {};
      for (final block in latinResult.blocks) {
        for (final line in block.lines) {
          final english = line.elements
              .map((e) => e.text.trim())
              .where((t) => RegExp(r'^[a-zA-Z]{3,}$').hasMatch(t))
              .join(' ');
          if (english.isNotEmpty) {
            final y = line.boundingBox.center.dy;
            englishByY[y] = english;
          }
        }
      }

      // 한국어 줄 추출: {centerY → korean text}
      final Map<double, String> koreanByY = {};
      for (final block in koreanResult.blocks) {
        for (final line in block.lines) {
          final korean = line.text.trim();
          if (RegExp(r'[가-힣]').hasMatch(korean)) {
            final y = line.boundingBox.center.dy;
            koreanByY[y] = korean;
          }
        }
      }

      // Y좌표 기준으로 영어 ↔ 한국어 매칭 (허용 오차 40px)
      const double yTolerance = 40.0;
      final words = <Word>[];
      final seen = <String>{};

      for (final engEntry in englishByY.entries) {
        final engText = engEntry.key == engEntry.key ? engEntry.value : '';
        final engY = engEntry.key;
        final lower = engText.toLowerCase();

        if (seen.contains(lower)) continue;
        seen.add(lower);

        // 가장 가까운 Y의 한국어 찾기
        String korean = '';
        double minDiff = yTolerance;
        for (final korEntry in koreanByY.entries) {
          final diff = (korEntry.key - engY).abs();
          if (diff < minDiff) {
            minDiff = diff;
            korean = korEntry.value;
          }
        }

        final word = Word.create(english: engText, korean: korean);
        words.add(word);
        _selectedWordIds.add(word.id);
      }

      if (mounted) {
        setState(() {
          _extractedWords = words;
          _isProcessing = false;
        });
      }
    } catch (e) {
      debugPrint("OCR Error: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedWordIds.contains(id)) {
        _selectedWordIds.remove(id);
      } else {
        _selectedWordIds.add(id);
      }
    });
  }

  void _createWordBook() {
    final selectedWords = _extractedWords.where((w) => _selectedWordIds.contains(w.id)).toList();
    if (selectedWords.isEmpty) return;

    final newBook = WordBook.create(
      title: "New Scan ${DateTime.now().minute}",
      iconName: "book", // default
      colorValue: 0xFF52B788,
    );
    newBook.words = selectedWords;

    ref.read(wordBookListProvider.notifier).addWordBook(newBook);

    // Go back to home
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: AppSpacing.paddingLg,
              decoration: const BoxDecoration(
                color: LightColors.secondary,
                border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTopButton(Icons.close_rounded, () => context.pop()),
                      _buildStepIndicator(),
                      _buildTopButton(Icons.edit_rounded, () {}),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "단어를 골라보세요!",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isProcessing
                            ? "스캔 중..."
                            : "사진에서 ${_extractedWords.length}개 단어를 찾았어요",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isProcessing
                  ? const Center(child: CircularProgressIndicator(color: LightColors.primary))
                  : SingleChildScrollView(
                padding: AppSpacing.paddingLg,
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                          Container(color: Colors.black.withOpacity(0.4)),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image_search_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  "원본 사진 보기",
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "인식된 단어",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: LightColors.primaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (_selectedWordIds.length == _extractedWords.length) {
                                _selectedWordIds.clear();
                              } else {
                                _selectedWordIds.addAll(_extractedWords.map((w) => w.id));
                              }
                            });
                          },
                          child: Text(
                            _selectedWordIds.length == _extractedWords.length ? "전체 해제" : "전체 선택",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: LightColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._extractedWords.map((word) => _buildWordChip(word, _selectedWordIds.contains(word.id))).toList(),
                  ],
                ),
              ),
            ),
            Container(
              padding: AppSpacing.paddingLg,
              decoration: const BoxDecoration(
                color: LightColors.surface,
                border: Border(top: BorderSide(color: Colors.black, width: 3)),
                boxShadow: [AppShadows.lg],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${_selectedWordIds.length}개 단어",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: LightColors.primaryText,
                        ),
                      ),
                      Text(
                        "선택됨",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: LightColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: GestureDetector(
                      onTap: _createWordBook,
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: LightColors.success,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [AppShadows.md],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "단어장 만들기",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: LightColors.primaryText,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward_rounded, color: LightColors.primaryText, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [AppShadows.sm],
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildDot(LightColors.success),
        const SizedBox(width: 8),
        _buildDot(LightColors.primary),
        const SizedBox(width: 8),
        _buildDot(LightColors.surface),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 32,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

  Widget _buildWordChip(Word word, bool selected) {
    return GestureDetector(
      onTap: () => _toggleSelection(word.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? LightColors.primary : LightColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: selected ? LightColors.primary : const Color(0xFF333333),
              width: 3
          ),
          boxShadow: [selected ? AppShadows.md : AppShadows.sm],
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
              color: selected ? LightColors.onPrimary : LightColors.primaryText,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.english,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: selected ? LightColors.onPrimary : LightColors.primaryText,
                    ),
                  ),
                  Text(
                    word.korean,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: selected ? LightColors.onPrimary : LightColors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.volume_up_rounded, color: LightColors.onPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}
