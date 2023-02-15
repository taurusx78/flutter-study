import 'package:flutter_delivery_app/order/model/order_model.dart';
import 'package:flutter_delivery_app/order/model/post_order_body.dart';
import 'package:flutter_delivery_app/order/repository/order_repository.dart';
import 'package:flutter_delivery_app/user/model/basket_item_model.dart';
import 'package:flutter_delivery_app/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);

  // 주문 요청
  Future<bool> postOrder() async {
    try {
      // 주문 ID 생성
      const uuid = Uuid();
      final id = uuid.v4();

      final List<BasketItemModel> basket = ref.read(basketProvider);

      // 주문 요청 및 응답받기
      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basket
              .map((e) =>
                  PostOrderBodyProduct(productId: e.product.id, count: e.count))
              .toList(),
          totalPrice:
              basket.fold<int>(0, (p, n) => p + n.product.price * n.count),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
