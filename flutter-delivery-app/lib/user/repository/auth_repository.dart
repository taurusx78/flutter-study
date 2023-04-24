import 'package:dio/dio.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio_interceptor.dart';
import 'package:flutter_delivery_app/common/model/login_response.dart';
import 'package:flutter_delivery_app/common/model/token_response.dart';
import 'package:flutter_delivery_app/common/utils/data_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로그인 요청 API
// 헤더를 통한 작업이 많아서 Retrofit 이용하지 않고 처리하도록 구현

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio: dio, baseUrl: 'http://$ip/auth');
});

class AuthRepository {
  final Dio dio;

  // http://$ip/auth
  final String baseUrl;

  AuthRepository({
    required this.dio,
    required this.baseUrl,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    // 로그인 정보 인코딩
    final token = DataUtils.plainToBase64('$username:$password');

    final resp = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {
          'authorization': 'Basic $token',
        },
      ),
    );

    return LoginResponse.fromJson(resp.data);
  }

  // Access 토큰 재발급 요청
  Future<TokenResponse> token() async {
    final resp = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
