import 'package:flutter_delivery_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

// 사용자 인증 진행중
class UserModelLoading extends UserModelBase {}

// 사용자 인증 에러
class UserModelError extends UserModelBase {
  final String message;

  UserModelError({required this.message});
}

// 인증된 사용자
@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
