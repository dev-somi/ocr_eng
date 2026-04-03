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
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 도형들
            Positioned(
              top: 40,
              left: -20,
              child: _buildBgShape(100, const Color(0xFFFFD60A), 0.3),
            ),
            Positioned(
              top: 80,
              right: -10,
              child: _buildBgShape(60, const Color(0xFF4CC9F0), 0.25),
            ),
            Positioned(
              bottom: 120,
              left: 20,
              child: _buildBgShape(80, const Color(0xFFFF6B6B), 0.2),
            ),
            Positioned(
              bottom: 200,
              right: 30,
              child: _buildBgShape(50, const Color(0xFFFFD60A), 0.35),
            ),

            // 메인 콘텐츠
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 카메라 아이콘 + 알파벳 배지
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 메인 원형 아이콘
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD60A),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 56,
                        color: Colors.black,
                      ),
                    ),
                    // A 배지
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "A",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 300.ms),

                const SizedBox(height: 32),

                // 앱 이름
                Text(
                  "ClickWord",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 300.ms,
                    duration: 500.ms,
                    curve: Curves.easeOut),

                const SizedBox(height: 10),

                // 서브타이틀
                Text(
                  "찍으면 단어장이 완성돼요 ✨",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                const SizedBox(height: 40),

                // 시작하기 버튼 (누를 수 없는 표시용)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD60A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Text(
                    "시작하기",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(
                    begin: 0.2, end: 0, delay: 700.ms, duration: 400.ms),
              ],
            ),

            // 하단 로딩 표시
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(0),
                      const SizedBox(width: 6),
                      _buildDot(200),
                      const SizedBox(width: 6),
                      _buildDot(400),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 900.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgShape(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDot(int delayMs) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(
          begin: 0.6,
          end: 1.0,
          delay: Duration(milliseconds: delayMs),
          duration: 600.ms,
          curve: Curves.easeInOut,
        );
  }
}
