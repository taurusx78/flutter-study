import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/state_provider.dart';

class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('재빌드됨');
    // watch: 상태값 변경 감지 후 재빌드함
    final state = ref.watch(numberProvider);

    return DefaultLayout(
      title: 'State Provider',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$state'),
            ElevatedButton(
              child: const Text('UP'),
              onPressed: () {
                // read: 상태값(state) 가져옴
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
            ),
            ElevatedButton(
              child: const Text('DOWN'),
              onPressed: () {
                ref.read(numberProvider.notifier).state =
                    ref.read(numberProvider.notifier).state - 1;
              },
            ),
            ElevatedButton(
              child: const Text('Next Screen'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const _NextScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NextScreen extends ConsumerWidget {
  const _NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(numberProvider);

    return DefaultLayout(
      title: 'State Provider Next Screen',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$state'),
            ElevatedButton(
              child: const Text('UP'),
              onPressed: () {
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
