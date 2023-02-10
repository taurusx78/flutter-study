import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final String? after; // 마지막 데이터 id
  final int? count; // 가져올 데이터 수

  const PaginationParams({
    this.after,
    this.count = 20,
  });

  PaginationParams copyWith({
    String? after,
    int? count,
  }) {
    return PaginationParams(
      after: after,
      count: count ?? this.count,
    );
  }

  // 쿼리스트링으로 직접 입력받은 after, count 값을 Json 데이터로 변환
  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
