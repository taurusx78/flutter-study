import 'package:flutter_riverpod/flutter_riverpod.dart';

// 관리하고 싶은 데이터 타입은 int, 값은 0
final numberProvider = StateProvider<int>((ref) => 0);
