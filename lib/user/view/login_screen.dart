import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/component/custom_text_form_field.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/secure_storage/secure_storage.dart';
import 'package:flutter_delivery_app/common/view/root_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        // 화면을 스크롤하면 키패드 사라지도록 설정
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16.0),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  child: const Text('로그인'),
                  onPressed: () async {
                    // 아이디:비밀번호
                    final rawString = '$username:$password';
                    // 문자열을 Base64로 변환
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    // Basic 토큰 생성
                    String token = stringToBase64.encode(rawString);

                    // 로그인 요청
                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    // resp.data: 응답 결과의 Body (Map 타입의 Json 데이터)
                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    // Secure Storage에 토큰 저장
                    final storage = ref.read(secureStorageProvider);
                    storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    // RootTab 페이지로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                ),
                TextButton(
                  child: const Text('회원가입'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
