import 'package:flutter_riverpod/flutter_riverpod.dart';

// 데이터가 필요 없어지면 캐시를 삭제하고, 필요할 때 다시 생성함
final autoDisposeModifierProvider =
    FutureProvider.autoDispose<List<int>>((ref) async {
  await Future.delayed(
    const Duration(seconds: 2),
  );
  return [1, 2, 3, 4, 5];
});
