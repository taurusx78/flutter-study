import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/view/root_tab.dart';
import 'package:flutter_delivery_app/common/view/splash_screen.dart';
import 'package:flutter_delivery_app/restaurant/view/basket_screen.dart';
import 'package:flutter_delivery_app/order/view/order_done_screen.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_delivery_app/user/model/user_model.dart';
import 'package:flutter_delivery_app/user/provider/user_me_provider.dart';
import 'package:flutter_delivery_app/user/view/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref: ref);
});

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    // userMeProvider의 상태값(UserModelBase? 타입) 변경 감지
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        // userMeProvider의 상태가 변경됐음을 외부에 알림 (Refresh 역할)
        notifyListeners();
      }
    });
  }

  // Splash Screen: 앱이 처음 시작될 때
  // 로그인 페이지로 이동할지, 홈 페이지로 이동할지
  // 토큰을 확인하는 과정을 거친다.
  String? redirectLogic(context, GoRouterState state) {
    print('auth_provider.dart - redirectLogic() 호출됨');
    print('현재 위치: ${state.location}');
    // 현재 사용자 상태
    final UserModelBase? user = ref.read(userMeProvider);
    // 현재 로그인 페이지에 있는지
    final loggingIn = state.location == '/login';

    if (user == null || user is UserModelError) {
      // 사용자 정보가 없을 때 (null, UserModelError)
      // 로그인 페이지가 아닌 경우 로그인 페이지로 이동
      return loggingIn ? null : '/login';
    } else if (user is UserModel) {
      // 사용자 정보가 있을 때
      // 스플래시 또는 로그인 페이지에 위치한 경우 홈 페이지로 이동
      return loggingIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelLoading 일 때는 스플래시 페이지 그대로 표시
    return null;
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.params['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => LoginScreen(),
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (_, state) => const BasketScreen(),
        ),
        GoRoute(
          path: '/order_done',
          name: OrderDoneScreen.routeName,
          builder: (_, state) => const OrderDoneScreen(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }
}
