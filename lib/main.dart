// 앱에서 사용하는 기능들을 불러오는 코드입니다.
// 단어 데이터를 저장하고 불러오는 기능
import 'package:clickword/data/repository.dart';
// 화면 이동(네비게이션) 설정
import 'package:clickword/nav.dart';
// 앱의 색상, 폰트 등 디자인 테마 설정
import 'package:clickword/theme.dart';
// Flutter의 기본 UI 구성 요소들
import 'package:flutter/material.dart';
// 화면 방향(세로/가로) 등 기기 설정을 제어하는 기능
import 'package:flutter/services.dart';
// 앱 전체에서 데이터를 쉽게 공유하기 위한 상태 관리 도구
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 앱이 시작될 때 가장 먼저 실행되는 함수입니다.
void main() async {
  // Flutter 엔진이 완전히 준비된 후에 초기화 작업을 수행하도록 보장합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // 단어 데이터를 관리하는 저장소를 만들고 초기화합니다.
  final repository = WordRepository();
  await repository.init();      // 데이터베이스 연결 등 초기 설정
  await repository.seedData();  // 앱에 기본으로 필요한 단어 데이터를 넣어줍니다.

  // 앱 화면을 항상 세로 방향으로만 사용하도록 고정합니다.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 모드(정방향)만 허용
  ]);

  // 앱을 실행합니다.
  runApp(
    // ProviderScope: 앱 전체에서 데이터를 공유할 수 있는 공간을 만들어줍니다.
    ProviderScope(
      overrides: [
        // 앱 어디서든 단어 저장소에 접근할 수 있도록 등록합니다.
        repositoryProvider.overrideWithValue(repository),
      ],
      child: const ClickWordApp(), // 실제 앱 화면을 시작합니다.
    ),
  );
}

// 앱 전체의 기본 틀을 정의하는 클래스입니다.
// 테마(디자인), 화면 이동 방식 등 앱의 뼈대를 구성합니다.
class ClickWordApp extends StatelessWidget {
  const ClickWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ClickWord',               // 앱의 이름 (기기 작업 목록 등에 표시됨)
      debugShowCheckedModeBanner: false, // 개발 중에 표시되는 "DEBUG" 배너를 숨깁니다.
      theme: lightTheme,                 // 라이트 모드(밝은 화면) 테마 적용
      darkTheme: darkTheme,              // 다크 모드 테마도 구조적으로 준비되어 있습니다.
      themeMode: ThemeMode.light,        // 현재는 라이트 모드로 고정합니다.
      routerConfig: AppRouter.router,    // 화면 이동 경로(라우팅) 설정을 불러옵니다.
    );
  }
}
