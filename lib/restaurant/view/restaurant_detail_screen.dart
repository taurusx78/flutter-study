import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id; // 매장 id
  final String name; // 매장명

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);

  // 매장 상세데이터 요청
  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: name,
      child: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          // 아직 받은 데이터가 없는 경우
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final item = RestaurantDetailModel.fromJson(json: snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(model: item),
              renderLabel(),
              renderProducts(products: item.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<ProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ProductCard.fromModel(model: product),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
