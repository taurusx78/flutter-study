import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/select_provider.dart';

class SelectProviderScreen extends ConsumerWidget {
  const SelectProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('재빌드됨');

    // select: 특정 데이터 변경만 감지하며, 변경 시 재빌드됨
    final state = ref.watch(
      selectNotifierProvider.select((value) => value.isSpicy),
    );

    return DefaultLayout(
      title: 'Select Provider',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(state.name),
            // Text(state.hasBought.toString()),
            // ElevatedButton(
            //   child: const Text('Toggle HasBought'),
            //   onPressed: () {
            //     ref.read(selectNotifierProvider.notifier).toggleHasBought();
            //   },
            // ),
            Text(state.toString()),
            ElevatedButton(
              child: const Text('Toggle Spicy'),
              onPressed: () {
                ref.read(selectNotifierProvider.notifier).toggleIsSpicy();
              },
            ),
          ],
        ),
      ),
    );
  }
}
