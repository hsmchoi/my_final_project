// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen/components/home_screen.dart';

void main() {
  // URL 반영 설정
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(
    // ProviderScope는 앱 전체에서 상태 관리를 제공합니다.
    const ProviderScope(
      child: App(),
    ),
  );
}

// 앱의 루트 위젯입니다.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // GoRouter를 사용하여 라우팅을 설정합니다.
      home: const HomeScreen(),
    );
  }
}
