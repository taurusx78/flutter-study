import 'package:dio/dio.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 모든 Dio 요청에 대해 해당 인터셉터 실행됨

class DioInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  DioInterceptor({required this.storage});

  // 1. 요청을 보낼 때
  // Access 토큰 Header에 담아 요청
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 요청을 보내기 전
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $accessToken',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $refreshToken',
      });
    }

    // 요청을 보냄
    super.onRequest(options, handler);
  }

  // 2. 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RESP] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  // 3. 요청에 대해 에러가 났을 때
  // Access 토큰이 만료된 경우 (401 에러), Refresh 토큰을 이용해 재발급 받아 요청
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // Refresh 토큰이 없거나 만료된 경우
    if (refreshToken == null) {
      return handler.reject(err); // 에러를 던짐
    }

    // Access 토큰 만료로 에러가 발생했는지
    final isStatus401 = err.response?.statusCode == 401;
    // Access 토큰 재발급 요청에 대해 에러가 발생했는지 (없거나 만료된 Refresh 토큰)
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        // Refresh 토큰을 이용해 Access 토큰 재발급 요청
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        // Access 토큰 갱신
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;
        options.headers.addAll(
          {'authorization': 'Bearer $accessToken'},
        );
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 재발급 받은 Access 토큰을 이용해 요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response); // 에러 없이 종료
      } on DioError catch (e) {
        return handler.reject(e); // 에러 던짐
      }
    }

    return handler.reject(err); // 에러 던짐
  }
}
