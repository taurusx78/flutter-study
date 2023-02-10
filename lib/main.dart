import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/view/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
