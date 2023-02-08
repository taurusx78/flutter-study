import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/layout/default_layout.dart';
import 'package:go_router_practice/provider/auth_provider.dart';
import 'package:go_router_practice/screen/three_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            child: const Text('Go One Screen'),
            onPressed: () {
              context.go('/one');
            },
          ),
          ElevatedButton(
            child: const Text('Go Three Screen'),
            onPressed: () {
              // context.go('/one/two/three');
              context.goNamed(ThreeScreen.routeName);
            },
          ),
          ElevatedButton(
            child: const Text('Go Two Screen'),
            onPressed: () {
              // 없는 라우트 요청 -> 에러 페이지 표시
              context.go('/two');
            },
          ),
          ElevatedButton(
            child: const Text('Go Login Screen'),
            onPressed: () {
              ref.read(userProvider.notifier).logout();
              // context.go('/login');
            },
          )
        ],
      ),
    );
  }
}
