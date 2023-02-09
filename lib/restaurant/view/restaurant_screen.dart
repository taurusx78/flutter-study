import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';

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
            // 아직 받은 데이터가 없는 경우
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                // Json 데이터
                final Map<String, dynamic> item = snapshot.data![index];
                // RestaurantModel 타입의 데이터로 변경
                final pItem = RestaurantModel.fromJson(json: item);

                return GestureDetector(
                  child: RestaurantCard.fromModel(model: pItem),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          id: pItem.id,
                          name: pItem.name,
                        ),
                      ),
                    );
                  },
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
