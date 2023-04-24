import 'package:flutter_riverpod/flutter_riverpod.dart';

// 이전에 데이터를 가져온 적이 있는 경우 캐싱되어, 재요청 시 로딩 없이 바로 리턴됨
final multipleFutureProvider = FutureProvider<List<int>>((ref) async {
  await Future.delayed(
    const Duration(seconds: 2),
  );
  return [1, 2, 3, 4, 5];
});
