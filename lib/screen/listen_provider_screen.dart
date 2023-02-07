import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/listen_provider.dart';

class ListenProviderScreen extends ConsumerStatefulWidget {
  const ListenProviderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListenProviderScreen> createState() =>
      _ListenProviderScreenState();
}

class _ListenProviderScreenState extends ConsumerState<ListenProviderScreen>
    with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 10,
      vsync: this,
      initialIndex: ref.read(listenProvider), // 초기 인덱스 설정
    );
  }

  @override
  Widget build(BuildContext context) {
    print('재빌드됨');

    // listen: 상태값(state) 변경만 감지함
    ref.listen<int>(listenProvider, (previous, next) {
      print('previous: $previous, next: $next');
      controller.animateTo(next);
    });

    return DefaultLayout(
      title: 'Listen Provider',
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: List.generate(
          10,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$index',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: const Text('이전'),
                    onPressed: () {
                      ref
                          .read(listenProvider.notifier)
                          .update((state) => state > 0 ? state - 1 : 0);
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    child: const Text('다음'),
                    onPressed: () {
                      ref
                          .read(listenProvider.notifier)
                          .update((state) => state < 9 ? state + 1 : 9);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
