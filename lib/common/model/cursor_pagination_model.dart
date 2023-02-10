import 'package:json_annotation/json_annotation.dart';

// Cursor Pagination을 통해 가져온 메타 정보와 데이터를 담을 모델

part 'cursor_pagination_model.g.dart';

// 부모 클래스
abstract class CursorPaginationBase {}

// 로딩 상태
class CursorPaginationLoading extends CursorPaginationBase {}

// 에러 상태
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({required this.message});
}

// 기본 상태 (데이터 있음)
@JsonSerializable(
  genericArgumentFactories: true, // 코드 자동 생성 시 제너릭 타입을 고려하도록 설정
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count; // 가져온 데이터 개수
  final bool hasMore; // 더 가져올 수 있는 데이터가 남아있는지

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 새로고침 상태 (데이터 있음)
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required meta,
    required data,
  }) : super(
          meta: meta,
          data: data,
        );
}

// 더보기 요청 상태 (데이터 있음)
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required meta,
    required data,
  }) : super(
          meta: meta,
          data: data,
        );
}
