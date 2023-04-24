import 'package:flutter_delivery_app/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // read - 딱 한번만 읽어옴. 이후 상태가 변경되어도 GoRouter 유지됨
  // watch - 상태가 변경되면 새로운 GoRouter 반환
  final provider = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    // redirect
    redirect: provider.redirectLogic,
    // refresh: AuthNotifier의 상태가 변경됐을 때 redirect를 재실행함
    // -> 상태값 변경 감지가 필요하기 때문에, ChangeNotifier를 상속한 클래스를 받음
    refreshListenable: provider,
    routes: provider.routes,
  );
});
