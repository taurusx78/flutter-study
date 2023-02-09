import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image; // 매장사진
  final String name; // 매장명
  final List<String> tags; // 태그
  final double ratings; // 평균 평점
  final int ratingsCount; // 평점 개수
  final int deliveryTime; // 배송 시간
  final int deliveryFee; // 배송비

  const RestaurantCard({
    required this.image,
    required this.name,
    required this.tags,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 매장사진
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: image,
        ),
        const SizedBox(height: 16.0),
        Column(
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
          ],
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
