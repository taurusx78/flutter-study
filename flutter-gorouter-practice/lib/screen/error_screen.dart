import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/layout/default_layout.dart';

// 라우트 이동 시 에러가 발생하면 표시할 페이지 (예. 없는 페이지로 이동)

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({
    required this.error,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          Text(error),
          ElevatedButton(
            child: const Text('홈으로'),
            onPressed: () {
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
