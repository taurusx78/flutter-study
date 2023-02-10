import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image; // 매장사진
  final String name; // 매장명
  final List<String> tags; // 태그
  final double ratings; // 평균 평점
  final int ratingsCount; // 평점 개수
  final int deliveryTime; // 배송 시간
  final int deliveryFee; // 배송비

  final bool isDetail; // 상세카드 여부
  final String? detail; // 상세내용

  final String? heroTag; // Hero 위젯 태그

  const RestaurantCard({
    required this.image,
    required this.name,
    required this.tags,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    this.isDetail = false,
    this.detail,
    this.heroTag,
    Key? key,
  }) : super(key: key);

  // RestaurantModel 데이터를 받아 RestaurantCard 위젯 생성
  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratings: model.ratings,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
      heroTag: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 매장사진
        if (heroTag != null)
          Hero(
            tag: ObjectKey(heroTag),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(!isDetail ? 8.0 : 0),
              child: image,
            ),
          ),
        if (heroTag == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(!isDetail ? 8.0 : 0),
            child: image,
          ),
        const SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: !isDetail ? 0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 매장명
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              // 태그
              Text(
                tags.join(' · '),
                style: const TextStyle(
                  color: BODY_TEXT_COLOR,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  // 평균 평점
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  // 평점 개수
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  renderDot(),
                  // 배송 시간
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  renderDot(),
                  // 배송비
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee != 0 ? deliveryFee.toString() : '무료',
                  ),
                ],
              ),
              if (isDetail && detail != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }

  renderDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
