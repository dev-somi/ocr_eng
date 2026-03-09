import 'package:clickword/data/repository.dart';
import 'package:clickword/nav.dart';
import 'package:clickword/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repository
  final repository = WordRepository();
  await repository.init();
  await repository.seedData();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repository),
      ],
      child: const ClickWordApp(),
    ),
  );
}

class ClickWordApp extends StatelessWidget {
  const ClickWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ClickWord',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme, // We only designed light theme mostly, but structure supports dark
      themeMode: ThemeMode.light, // Force light mode for now as per design
      routerConfig: AppRouter.router,
    );
  }
}
