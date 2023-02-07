import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/future_provider.dart';

class FutureProviderScreen extends ConsumerWidget {
  const FutureProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multipleFutureProvider);

    return DefaultLayout(
      title: 'Future Provider',
      body: Center(
        child: state.when(
          // 로딩후 데이터를 반환받은 경우
          data: (data) => Text(
            '$data',
            textAlign: TextAlign.center,
          ),
          // 에러가 발생한 경우
          error: (error, stack) => Text('$error'),
          // 로딩중인 경우
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
