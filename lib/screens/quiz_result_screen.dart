import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result['score'] as int? ?? 0;
    final total = result['total'] as int? ?? 100;
    final correctCount = result['correctCount'] as int? ?? 0;
    final totalCount = result['totalCount'] as int? ?? 0;
    final accuracy = totalCount == 0 ? 0 : ((correctCount / totalCount) * 100).toInt();

    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 340,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD166).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -30,
                      top: 50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CC9F0).withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Icon(Icons.emoji_events_rounded, size: 120, color: Color(0xFFFFD166)), // Mascot placeholder
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Amazing Job!",
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: LightColors.primaryText,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "You're becoming a word master!",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: LightColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: LightColors.primaryText, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "SCORE",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: LightColors.primaryText,
                              ),
                            ),
                            Text(
                              "$score",
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: LightColors.primaryText,
                                fontSize: 48,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 4,
                          height: 60,
                          color: LightColors.primaryText.withOpacity(0.2),
                        ),
                        Column(
                          children: [
                            Text(
                              "ACCURACY",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: LightColors.primaryText,
                              ),
                            ),
                            Text(
                              "$accuracy%",
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: LightColors.primaryText,
                                fontSize: 48,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatPill(
                        context,
                        Icons.timer_rounded,
                        const Color(0xFF4CC9F0),
                        "Time",
                        "02:45", // Mock
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatPill(
                        context,
                        Icons.local_fire_department_rounded,
                        const Color(0xFFEF476F),
                        "Streak",
                        "5 Days", // Mock
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Review Words",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: LightColors.primaryText,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: LightColors.success,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            "$correctCount/$totalCount Correct",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: LightColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // In a real app, list actual words reviewed
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(), // Retry logic needed, or just pop to retry
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B9BD5),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: LightColors.primaryText, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.replay_rounded, color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Try Again",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.home),
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: LightColors.primaryText, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home_rounded, color: Colors.black, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Back to Home",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(BuildContext context, IconData icon, Color color, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color, width: 3),
        boxShadow: const [AppShadows.sm],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: LightColors.secondaryText,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: LightColors.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
