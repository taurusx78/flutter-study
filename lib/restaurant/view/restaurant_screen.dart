import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  // 매장 목록 20개 요청
  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(headers: {
        'authorization': 'Bearer $accessToken',
      }),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List>(
          future: paginateRestaurant(),
          builder: (_, AsyncSnapshot<List> snapshot) {
            // 아직 데이터를 받지않은 경우
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final item = snapshot.data![index];

                return RestaurantCard(
                  image: Image.network(
                    'http://$ip${item['thumbUrl']}',
                    fit: BoxFit.cover,
                  ),
                  name: item['name'],
                  tags: List<String>.from(item['tags']),
                  ratings: item['ratings'],
                  ratingsCount: item['ratingsCount'],
                  deliveryTime: item['deliveryTime'],
                  deliveryFee: item['deliveryFee'],
                );
              },
              separatorBuilder: (_, index) => const SizedBox(height: 16.0),
            );
          },
        ),
      ),
    );
  }
}
