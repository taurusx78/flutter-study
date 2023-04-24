import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio_interceptor.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_delivery_app/common/repository/base_pagination_repository.dart';
import 'package:flutter_delivery_app/rating/model/rating_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'rating_repository.g.dart';

final ratingRepositoryProvider =
    Provider.family<RatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);
  final repository =
      RatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
  return repository;
});

@RestApi()
abstract class RatingRepository
    implements IBasePaginationRepository<RatingModel> {
  // baseUrl: http://$ip/restaurant/:rid/rating
  factory RatingRepository(Dio dio, {String? baseUrl}) = _RatingRepository;

  // http://$ip/restaurant/:id/rating
  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams paginationParams = const PaginationParams(),
  });
}
