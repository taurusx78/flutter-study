import 'package:flutter_delivery_app/common/utils/data_utils.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

// 매장 상세데이터 요청 후 응답받은 Json 데이터를 담을 모델
// @JsonSerializable()을 통해 fromJson 코드 자동 생성

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required id,
    required name,
    required thumbUrl,
    required tags,
    required priceRange,
    required ratings,
    required ratingsCount,
    required deliveryTime,
    required deliveryFee,
    required this.detail,
    required this.products,
  }) : super(
          id: id,
          name: name,
          thumbUrl: thumbUrl,
          tags: List<String>.from(tags),
          priceRange: RestaurantPriceRange.values
              .firstWhere((element) => element.name == priceRange),
          ratings: ratings,
          ratingsCount: ratingsCount,
          deliveryTime: deliveryTime,
          deliveryFee: deliveryFee,
        );

  // Json 데이터를 바탕으로 RestaurantDetailModel 데이터 생성
  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);

  // factory RestaurantDetailModel.fromJson({required Map<String, dynamic> json}) {
  //   return RestaurantDetailModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: json['thumbUrl'],
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values
  //         .firstWhere((element) => json['priceRange'] == element.name),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //     detail: json['detail'],
  //     products: json['products']
  //         .map<ProductModel>(
  //           (x) => ProductModel.fromJson(json: x),
  //         )
  //         .toList(),
  //   );
  // }
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);
}
