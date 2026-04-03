import 'package:clickword/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:clickword/nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primary,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildFloatingParticle(40, LightColors.secondary, -0.8, -0.7),
            _buildFloatingParticle(24, LightColors.accent, 0.7, -0.5),
            _buildFloatingParticle(60, LightColors.onPrimary, -0.5, 0.4),
            _buildFloatingParticle(32, LightColors.secondary, 0.8, 0.8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                        .rotate(begin: 0, end: 0.05, duration: 2000.ms, curve: Curves.easeInOut)
                        .then()
                        .rotate(begin: 0.05, end: 0, duration: 2000.ms, curve: Curves.easeInOut),

                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                        .rotate(begin: 0, end: -0.05, duration: 2500.ms, curve: Curves.easeInOut)
                        .then()
                        .rotate(begin: -0.05, end: 0, duration: 2500.ms, curve: Curves.easeInOut),

                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: LightColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: [AppShadows.xl],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_rounded, size: 64, color: LightColors.primary),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              "ABC",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: LightColors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Column(
                  children: [
                    Text(
                      "ClickWord",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: LightColors.onPrimary,
                        fontSize: 48,
                      ),
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: LightColors.secondary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        "AI 영단어 수집기",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: LightColors.onSecondary,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Column(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: LightColors.secondary,
                        strokeWidth: 6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      "교재를 찍으면 단어가 쏙쏙!",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: LightColors.onPrimary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "기술 지원",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: LightColors.onPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 16, color: LightColors.secondary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        "스마트 OCR 엔진",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: LightColors.onPrimary,
                        ),
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

  Widget _buildFloatingParticle(double size, Color color, double alignX, double alignY) {
    return Align(
      alignment: Alignment(alignX, alignY),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: 0, end: 20, duration: 2000.ms, curve: Curves.easeInOut);
  }
}
