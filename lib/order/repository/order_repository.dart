import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio_interceptor.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_delivery_app/common/repository/base_pagination_repository.dart';
import 'package:flutter_delivery_app/order/model/order_model.dart';
import 'package:flutter_delivery_app/order/model/post_order_body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = OrderRepository(dio, baseUrl: 'http://$ip/order');
  return repository;
});

@RestApi()
abstract class OrderRepository
    implements IBasePaginationRepository<OrderModel> {
  // baseUrl: http://$ip/order
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  // 전체 주문 목록 조회
  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<OrderModel>> paginate({
    @Queries() PaginationParams paginationParams = const PaginationParams(),
  });

  // 주문 요청
  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
