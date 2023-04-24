import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio_interceptor.dart';
import 'package:flutter_delivery_app/user/model/basket_item_model.dart';
import 'package:flutter_delivery_app/user/model/patch_basket_body.dart';
import 'package:flutter_delivery_app/user/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
  return repository;
});

@RestApi()
abstract class UserMeRepository {
  // baseUrl: http://$ip/user/me
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  // 사용자 정보 조회
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();

  // 장바구니 조회
  @GET('/basket')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BasketItemModel>> getBasket();

  // 장바구니 업데이트
  @PATCH('/basket')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BasketItemModel>> patchBasket({
    // toJson()이 실행되어 PatchBasketBody 타입의 데이터가 Json 데이터로 변환되어 전송됨
    @Body() required PatchBasketBody body,
  });
}
