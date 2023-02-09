import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/view/root_tab.dart';
import 'package:flutter_delivery_app/user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  // 토큰 유효성 검사
  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    // Access 토큰 재발급 요청
    try {
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(headers: {
          'authorization': 'Bearer $refreshToken',
        }),
      );

      // Access 토큰 갱신
      final accessToken = resp.data['accessToken'];
      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
        (route) => false,
      );
    } catch (e) {
      // Refresh 토큰 만료, Access 토큰 재발급 실패
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  // 토큰 삭제
  void deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        // Column 위젯의 너비 최대화 -> 가운데 정렬 효과
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
