import 'package:clickword/screens/camera_screen.dart';
import 'package:clickword/screens/flashcard_screen.dart';
import 'package:clickword/screens/home_screen.dart';
import 'package:clickword/screens/quiz_result_screen.dart';
import 'package:clickword/screens/quiz_screen.dart';
import 'package:clickword/screens/settings_screen.dart';
import 'package:clickword/screens/splash_screen.dart';
import 'package:clickword/screens/stats_screen.dart';
import 'package:clickword/screens/word_book_detail_screen.dart';
import 'package:clickword/screens/word_selection_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.camera,
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: AppRoutes.wordSelection,
        name: 'wordSelection',
        builder: (context, state) {
          final imagePath = state.extra as String;
          return WordSelectionScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: AppRoutes.wordBookDetail,
        name: 'wordBookDetail',
        builder: (context, state) {
          final wordBookId = state.extra as String;
          return WordBookDetailScreen(wordBookId: wordBookId);
        },
      ),
      GoRoute(
        path: AppRoutes.flashcard,
        name: 'flashcard',
        builder: (context, state) {
          final wordBookId = state.extra as String;
          return FlashcardScreen(wordBookId: wordBookId);
        },
      ),
      GoRoute(
        path: AppRoutes.quiz,
        name: 'quiz',
        builder: (context, state) {
          final wordBookId = state.extra as String;
          return QuizScreen(wordBookId: wordBookId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizResult,
        name: 'quizResult',
        builder: (context, state) {
          final result = state.extra as Map<String, dynamic>;
          return QuizResultScreen(result: result);
        },
      ),
      GoRoute(
        path: AppRoutes.stats,
        name: 'stats',
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String camera = '/camera';
  static const String wordSelection = '/word_selection';
  static const String wordBookDetail = '/word_book_detail';
  static const String flashcard = '/flashcard';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz_result';
  static const String stats = '/stats';
  static const String settings = '/settings';
}
