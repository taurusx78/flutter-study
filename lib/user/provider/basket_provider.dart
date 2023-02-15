import 'package:collection/collection.dart';
import 'package:flutter_delivery_app/product/model/product_model.dart';
import 'package:flutter_delivery_app/user/model/basket_item_model.dart';
import 'package:flutter_delivery_app/user/model/patch_basket_body.dart';
import 'package:flutter_delivery_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketStateNotifier, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketStateNotifier(repository: repository);
});

class BasketStateNotifier extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketStateNotifier({
    required this.repository,
  }) : super([]);

  // 장바구니 API 요청
  Future<void> patchBasket() async {
    repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map((e) => PatchBasketBodyBasket(
                  productId: e.product.id,
                  count: e.count,
                ))
            .toList(),
      ),
    );
  }

  // 장바구니에 상품 추가
  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 기존 동작 방식: 요청 후 응답이 오면 캐시 업데이트
    // 장바구니 동작 방식: 응답오기 전 캐시 업데이트
    // -> Optimistic Response(긍정적 응답): 응답이 성공할거라 가정하고 상태를 먼저 업데이트 함

    // *** 캐시 업데이트 ***
    // 장바구니에 상품이 있는지 확인
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      // 1. 상품이 있는 경우, 상품 개수 + 1
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.codyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      // 2. 상품이 없는 경우, 상품 추가
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }

    // *** 요청 및 응답받기 ***
    await patchBasket();
  }

  // 장바구니에서 상품 삭제
  Future<void> removeToBasket({
    required ProductModel product,
    // true - 남은 개수와 관계 없이 삭제함
    bool isDelete = false,
  }) async {
    // *** 캐시 업데이트 ***
    // 장바구니에 상품이 있는지 확인
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      // 1. 상품이 있는 경우, 남은 개수가 1보다 크면 -1, 1이면 삭제
      final existingProduct =
          state.firstWhere((e) => e.product.id == product.id);

      if (existingProduct.count == 1 || isDelete) {
        state = state
            .where(
              (e) => e.product.id != product.id,
            )
            .toList();
      } else {
        state = state
            .map(
              (e) => e.product.id == product.id
                  ? e.codyWith(
                      count: e.count - 1,
                    )
                  : e,
            )
            .toList();
      }
    } else {
      // 2. 상품이 없는 경우, 그냥 리턴
      return;
    }

    // *** 요청 및 응답받기 ***
    await patchBasket();
  }
}
