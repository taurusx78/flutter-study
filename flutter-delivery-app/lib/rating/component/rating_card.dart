import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/rating/model/rating_model.dart';

class RatingCard extends StatelessWidget {
  // ImageProvider: NetworkImage, AssetImage 등
  final ImageProvider userImage; // 사용자 이미지
  final List<Image> images; // 리뷰 이미지 리스트
  final String username; // 사용자 ID
  final int rating; // 별점
  final String content; // 내용

  const RatingCard({
    required this.username,
    required this.images,
    required this.userImage,
    required this.rating,
    required this.content,
    Key? key,
  }) : super(key: key);

  factory RatingCard.fromModel({
    required RatingModel model,
  }) {
    return RatingCard(
      userImage: NetworkImage(model.user.imageUrl),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      username: model.user.username,
      rating: model.rating,
      content: model.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          userImage: userImage,
          username: username,
          rating: rating,
        ),
        const SizedBox(height: 8.0),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          Container(
            // 높이 지정 필수!
            height: 100,
            margin: const EdgeInsets.only(top: 8.0),
            child: _Images(
              images: images,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider userImage;
  final String username;
  final int rating;

  const _Header({
    required this.userImage,
    required this.username,
    required this.rating,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 사용자 이미지
        CircleAvatar(
          radius: 12.0,
          backgroundImage: userImage,
        ),
        const SizedBox(width: 8.0),
        // 사용자 ID
        Expanded(
          child: Text(
            username,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // 별점
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
            size: 16.0,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({required this.images, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (_, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: images[index],
        );
      },
      separatorBuilder: (_, index) => const SizedBox(width: 8.0),
    );
  }
}
