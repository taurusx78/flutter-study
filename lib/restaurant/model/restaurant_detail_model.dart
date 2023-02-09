import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';

class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<ProductModel> products;

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
          tags: tags,
          priceRange: priceRange,
          ratings: ratings,
          ratingsCount: ratingsCount,
          deliveryTime: deliveryTime,
          deliveryFee: deliveryFee,
        );

  // Json 데이터를 바탕으로 RestaurantDetailModel 데이터 생성
  factory RestaurantDetailModel.fromJson({required Map<String, dynamic> json}) {
    return RestaurantDetailModel(
      id: json['id'],
      name: json['name'],
      thumbUrl: json['thumbUrl'],
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantPriceRange.values
          .firstWhere((element) => json['priceRange'] == element.name),
      ratings: json['ratings'],
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
      detail: json['detail'],
      products: json['products']
          .map<ProductModel>(
            (x) => ProductModel.fromJson(json: x),
          )
          .toList(),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  ProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory ProductModel.fromJson({required Map<String, dynamic> json}) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imgUrl: json['imgUrl'],
      detail: json['detail'],
      price: json['price'],
    );
  }
}
