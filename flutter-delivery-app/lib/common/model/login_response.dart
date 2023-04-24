import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

// 로그인 성공 시 응답 데이터(Refresh, Access 토큰) 담김

@JsonSerializable()
class LoginResponse {
  final String refreshToken;
  final String accessToken;

  LoginResponse({
    required this.refreshToken,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
