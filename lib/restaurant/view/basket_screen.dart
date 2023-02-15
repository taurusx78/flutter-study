import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/order/provider/order_provider.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/view/order_done_screen.dart';
import 'package:flutter_delivery_app/user/model/basket_item_model.dart';
import 'package:flutter_delivery_app/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BasketItemModel> basket = ref.watch(basketProvider);

    // 장바구니가 빈 경우
    if (basket.isEmpty) {
      return const DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text('장바구니가 비어있습니다.'),
        ),
      );
    }

    final int totalPrice =
        basket.fold<int>(0, (p, n) => p + n.product.price * n.count);
    final int deliveryFee = basket[0].product.restaurant.deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: basket.length,
                  itemBuilder: (_, index) {
                    final product = basket[index].product;
                    return ProductCard.fromProductModel(
                      model: product,
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeToBasket(product: product);
                      },
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: product);
                      },
                    );
                  },
                  separatorBuilder: (_, index) => const Divider(height: 32.0),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '장바구니 금액',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text(
                        '￦$totalPrice',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '배달비',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      if (basket.isNotEmpty) Text('￦$deliveryFee'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '총액',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text('￦${totalPrice + deliveryFee}'),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: const Text('결제하기'),
                      onPressed: () async {
                        // 주문 요청
                        final bool resp =
                            await ref.read(orderProvider.notifier).postOrder();
                        if (resp) {
                          // 주문 완료 페이지로 이동
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('결제에 실패하였습니다.'),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
