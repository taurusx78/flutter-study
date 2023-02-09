import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

// Retrofit 라이브러리가 API 요청 코드를 자동 생성해 줌

@RestApi()
abstract class RestaurantRepository {
  // baseUrl: Http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id
  // 응답받은 Json 데이터의 키가 RestaurantDetailModel 속성과 일치하면
  // 자동으로 RestaurantDetailModel 타입의 데이터로 리턴해줌
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
