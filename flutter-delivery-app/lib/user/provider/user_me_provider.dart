import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/model/login_response.dart';
import 'package:flutter_delivery_app/common/secure_storage/secure_storage.dart';
import 'package:flutter_delivery_app/user/model/user_model.dart';
import 'package:flutter_delivery_app/user/repository/auth_repository.dart';
import 'package:flutter_delivery_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final repository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
      authRepository: authRepository, repository: repository, storage: storage);
});

// 아직 로그인하지 않은 경우 상태 값은 null
class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 사용자 정보 가져오기
    getMe();
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      // 로딩중 상태로 변경
      state = UserModelLoading();

      final LoginResponse resp =
          await authRepository.login(username: username, password: password);

      // storage 저장소에 응답받은 토큰 저장
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      // 발급받은 토큰을 이용해 사용자 정보 가져오기 (토큰 유효성 검사)
      final UserModel userResp = await repository.getMe();

      // UserModel 상태로 변경
      state = userResp;
      return userResp;
    } catch (e) {
      // 에러 상태로 변경
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    // storage 저장소에 있는 토큰 삭제
    Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // 저장된 토큰이 없는 경우, 그냥 리턴
    if (refreshToken == null || accessToken == null) {
      state = null; // 로그아웃 상태로 변경
      return;
    }

    // Access 토큰을 이용해 사용자 정보 가져오기
    final UserModel resp = await repository.getMe();
    state = resp;
  }
}
