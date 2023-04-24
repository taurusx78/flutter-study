import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  // Provider 상태값이 변경된 경우 실행됨
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    print(
        '[Provider Updated] provider: $provider / pv: $previousValue / nv: $newValue');
  }

  // Provider가 생성된 경우 실행됨
  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    print('[Provider Added] provider: $provider / value: $value');
  }

  // Provider가 삭제된 경우 실행됨
  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    print('[Provider Disposed] provider: $provider');
  }
}
