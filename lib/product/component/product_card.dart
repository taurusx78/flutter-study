import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/product/model/product_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/user/model/basket_item_model.dart';
import 'package:flutter_delivery_app/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
    this.onSubtract,
    this.onAdd,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      name: model.name,
      imgUrl: model.imgUrl,
      detail: model.detail,
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      name: model.name,
      imgUrl: model.imgUrl,
      detail: model.detail,
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              // 메뉴사진
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imgUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 메뉴명
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // 메뉴설명
                    Text(
                      detail,
                      maxLines: 2,
                      // maxLine을 넘어가면 말줄임 표시
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14.0,
                      ),
                    ),
                    // 가격
                    Text(
                      '￦$price',
                      style: const TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
              id: id,
              price: price,
              onSubtract: onSubtract!,
              onAdd: onAdd!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends ConsumerWidget {
  final String id;
  final int price;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    required this.id,
    required this.price,
    required this.onSubtract,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BasketItemModel> basket = ref.watch(basketProvider);
    BasketItemModel? item = basket.firstWhereOrNull((e) => e.product.id == id);
    int count = item != null ? item.count : 0;
    int total = count * price;

    return Row(
      children: [
        // 합계
        Expanded(
          child: Text(
            '총액 ￦$total',
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            // 감소 버튼
            renderButton(
              icon: Icons.remove,
              onTap: onSubtract,
            ),
            const SizedBox(width: 8.0),
            // 개수
            Text(
              '$count',
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            // 증가 버튼
            renderButton(
              icon: Icons.add,
              onTap: onAdd,
            ),
          ],
        ),
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
      ),
      child: InkWell(
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
        onTap: onTap,
      ),
    );
  }
}
