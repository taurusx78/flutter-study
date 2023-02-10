import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 캐싱된 매장 상세 데이터(RestaurantModel 타입) 가져옴
// 한 번 가져오면 매장 상세 데이터 캐싱됨

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((e) => e.id == id);
});

// 서버로부터 가져온 매장 목록 데이터(List<RestaurantModel> 타입)가 캐싱됨

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required repository})
      : super(repository: repository);

  void getDetail({
    required String id,
  }) async {
    // 아직 불러온 데이터가 없는 경우 (CursorPagination이 아닌 경우)
    // 매장 목록 20개 가져오기
    if (state is! CursorPagination) {
      await paginate();
    }

    // 그럼에도 상태가 CursorPagination이 아니라면, 함수 종료
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    // 매장 상세 데이터 요청 및 응답받기
    final resp = await repository.getRestaurantDetail(id: id);

    // RestaurantModel 타입 데이터를 RestaurantDetailModel 타입으로 변경
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>((e) => e.id == id ? resp : e)
          .toList(),
    );
  }
}
