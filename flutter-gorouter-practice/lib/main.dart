import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_practice/provider/auth_provider.dart';

void main() {
  runApp(
    ProviderScope(child: _App()),
  );
}

class _App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // 라우트 정보 전달 역할
      routeInformationProvider: router.routeInformationProvider,
      // URI String을 GoRouter에서 사용할 수 있는 형태로 변환해주는 함수
      routeInformationParser: router.routeInformationParser,
      // 위에서 변경된 값에 대해 어떤 라우트를 보여줄 지 정하는 함수
      routerDelegate: router.routerDelegate,
    );
  }
}
