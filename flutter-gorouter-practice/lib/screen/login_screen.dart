import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_practice/layout/default_layout.dart';
import 'package:go_router_practice/provider/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              ref.read(userProvider.notifier).login(name: 'Jin');
            },
          ),
        ],
      ),
    );
  }
}
