import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  const ProductCard({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromModel({required ProductModel model}) {
    return ProductCard(
      id: model.id,
      name: model.name,
      imgUrl: 'http://$ip${model.imgUrl}',
      detail: model.detail,
      price: model.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
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
                  '$price',
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
    );
  }
}
