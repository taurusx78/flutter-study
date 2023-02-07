import 'package:flutter_riverpod/flutter_riverpod.dart';

// 외부에서 int 타입의 data를 입력받아 처리함
final familyModifierProvider =
    FutureProvider.family<List<int>, int>((ref, data) async {
  await Future.delayed(
    const Duration(seconds: 2),
  );
  return List.generate(5, (index) => index * data);
});
