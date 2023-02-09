import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio_interceptor.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  // 매장 목록 20개 요청
  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();
    // Dio 인터셉터 추가
    dio.interceptors.add(DioInterceptor(storage: storage));
    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<RestaurantModel>>(
          future: paginateRestaurant(),
          builder: (_, AsyncSnapshot<List<RestaurantModel>> snapshot) {
            // 아직 받은 데이터가 없는 경우
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final pItem = snapshot.data![index];

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
