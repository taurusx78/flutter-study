import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

// Access 토큰 재발급 성공 시 응답 데이터(Access 토큰) 담김

@JsonSerializable()
class TokenResponse {
  final String accessToken;

  TokenResponse({required this.accessToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}
