import 'package:flutter_riverpod/flutter_riverpod.dart';

// 이전에 데이터를 가져온 적이 있는 경우 캐싱되어, 재요청 시 로딩 없이 바로 리턴됨
final multipleStreamProvider = StreamProvider<List<int>>((ref) async* {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    yield List.generate(3, (index) => index * i);
  }
});
