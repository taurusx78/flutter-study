import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/order/model/order_model.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate; // 주문 날짜
  final Image image; // 매장 이미지
  final String name; // 매장명
  final String productsDetail; // 주문 상품 설명
  final int price; // 주문 총액

  const OrderCard({
    required this.orderDate,
    required this.image,
    required this.name,
    required this.productsDetail,
    required this.price,
    Key? key,
  }) : super(key: key);

  factory OrderCard.fromModel({
    required OrderModel model,
  }) {
    final productsDetail = model.products.length == 1
        ? model.products.first.product.name
        : '${model.products.first.product.name} 외 ${model.products.length - 1}개';

    return OrderCard(
      orderDate: model.createdAt,
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50.0,
        width: 50.0,
        fit: BoxFit.cover,
      ),
      name: model.restaurant.name,
      productsDetail: productsDetail,
      price: model.totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 주문날짜
        Text(
            '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료'),
        const SizedBox(height: 8.0),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상품명
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                // 상품 설명 & 가격
                Text(
                  '$productsDetail $price원',
                  style: const TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
