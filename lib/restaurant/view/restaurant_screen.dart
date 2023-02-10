import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이 위치에 근접하다면 추가 데이터 요청
    // - controller.offset: 스크롤 현재 위치
    // - controller.position.maxScrollExtent: 최대로 스크롤 가능한 길이
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CursorPaginationBase state = ref.watch(restaurantProvider);

    if (state is CursorPaginationLoading) {
      // 로딩 상태
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CursorPaginationError) {
      // 에러 상태
      return Center(
        child: Text(state.message),
      );
    }

    // CursorPagination, CursorPaginationRefetching, CursorPaginationFetchingMore 상태
    final cp = state as CursorPagination;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: state is CursorPaginationFetchingMore
                      ? const CircularProgressIndicator()
                      : const Text('마지막 데이터입니다.'),
                ),
              );
            }

            final pItem = cp.data[index];

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
        ),
      ),
    );
  }
}
