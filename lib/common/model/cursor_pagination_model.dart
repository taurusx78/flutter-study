import 'package:json_annotation/json_annotation.dart';

// Cursor Pagination을 통해 가져온 메타 정보와 데이터를 담을 모델

part 'cursor_pagination_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true, // 코드 자동 생성 시 제너릭 타입을 고려하도록 설정
)
class CursorPaginationModel<T> {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPaginationModel({
    required this.meta,
    required this.data,
  });

  factory CursorPaginationModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationModelFromJson(json, fromJsonT);
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
