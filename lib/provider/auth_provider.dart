import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/model/user_model.dart';

import '../screen/error_screen.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';
import '../screen/one_screen.dart';
import '../screen/three_screen.dart';
import '../screen/two_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStateProvider = AuthNotifier(ref: ref);

  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error.toString(),
    ),
    // redirect
    redirect: authStateProvider._redirectLogic,
    // refresh: AuthNotifier의 상태가 변경됐을 때 redirect를 재실행함
    // -> 상태값 변경 감지가 필요하기 때문에, ChangeNotifier를 상속한 클래스를 받음
    refreshListenable: authStateProvider,
    routes: authStateProvider._routes,
  );
});

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    // userProvider의 상태값(UserModel? 타입) 변경 감지
    ref.listen<UserModel?>(userProvider, (previous, next) {
      if (previous != next) {
        // AuthNotifier의 상태가 변경됐음을 외부에 알림 (Refresh 역할)
        notifyListeners();
      }
    });
  }

  String? _redirectLogic(context, GoRouterState state) {
    final user = ref.read(userProvider);

    // 현재 로그인 페이지에 있는지
    final loggingIn = state.location == '/login';

    // 유저 정보가 없고 (로그인하지 않은 상태)
    // 현재 로그인 페이지가 아닌 경우
    // 로그인 페이지로 이동
    // null: 원래 요청한 페이지로 이동
    if (user == null) {
      return loggingIn ? null : '/login';
    } else {
      // 유저 정보가 있는데 로그인 페이지인 경우
      // 홈 페이지로 이동
      return loggingIn ? '/' : null;
    }
  }

  List<GoRoute> get _routes => [
        // http://.../
        GoRoute(
          path: '/',
          builder: (_, state) => const HomeScreen(),
          routes: [
            // http://.../one
            GoRoute(
              path: 'one',
              builder: (_, state) => const OneScreen(),
              routes: [
                // http://.../one/two
                GoRoute(
                  path: 'two',
                  builder: (_, state) => const TwoScreen(),
                  routes: [
                    // http://.../one/two/three
                    GoRoute(
                      path: 'three',
                      name: ThreeScreen.routeName,
                      builder: (_, state) => const ThreeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/three',
          builder: (_, state) => const ThreeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) => const LoginScreen(),
        ),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

// 상태 관리할 데이터의 타입은 UserModel?
class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  login({
    required String name,
  }) {
    state = UserModel(name: name);
  }

  logout() {
    state = null;
  }
}
