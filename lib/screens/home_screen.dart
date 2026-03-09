import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:clickword/providers/wordbook_provider.dart';
import 'package:clickword/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordBooks = ref.watch(wordBookListProvider);

    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, Min-jun! 👋",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: LightColors.secondaryText,
                        ),
                      ),
                      Text(
                        "Ready to study?",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: LightColors.primaryText,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: LightColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: const Icon(Icons.face_rounded, size: 32, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              GestureDetector(
                onTap: () => context.push(AppRoutes.stats),
                child: Container(
                  padding: AppSpacing.paddingXl,
                  decoration: BoxDecoration(
                    color: LightColors.success,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Goal",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "12/20 Words",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: const Text(
                              "60%",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Stack(
                        children: [
                          Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              border: Border.all(color: Colors.black, width: 3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProgressStat(context, "5", "Days Streak"),
                          Container(width: 2, height: 40, color: Colors.black.withOpacity(0.15)),
                          _buildProgressStat(context, "128", "Total Words"),
                          Container(width: 2, height: 40, color: Colors.black.withOpacity(0.15)),
                          _buildProgressStat(context, "Quiz", "Next Step"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: () => context.push(AppRoutes.camera),
                child: Container(
                  padding: AppSpacing.paddingLg,
                  decoration: BoxDecoration(
                    color: LightColors.error,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_camera_rounded, color: Colors.white, size: 32),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        "Scan New Words",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Wordbooks",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: LightColors.primaryText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: LightColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip(context, "All", true),
                    _buildCategoryChip(context, "School", false),
                    _buildCategoryChip(context, "Academy", false),
                    _buildCategoryChip(context, "Favorites", false),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (wordBooks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.library_books_rounded, size: 64, color: LightColors.hint),
                        const SizedBox(height: 16),
                        Text(
                          "No wordbooks yet!",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: LightColors.secondaryText),
                        ),
                        Text(
                          "Tap 'Scan New Words' to create one.",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LightColors.hint),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...wordBooks.map((book) => _buildWordBookCard(context, book)).toList(),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? LightColors.primary : LightColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: selected ? LightColors.onPrimary : LightColors.primaryText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWordBookCard(BuildContext context, WordBook book) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.wordBookDetail, extra: book.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: LightColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: LightColors.divider, width: 3),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Color(book.colorValue),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Icon(
                _getIconData(book.iconName),
                color: Colors.black,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: LightColors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${book.words.length} Words",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: LightColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'pets_rounded': return Icons.pets_rounded;
      case 'description_rounded': return Icons.description_rounded;
      case 'science_rounded': return Icons.science_rounded;
      case 'error_outline_rounded': return Icons.error_outline_rounded;
      default: return Icons.book_rounded;
    }
  }
}
