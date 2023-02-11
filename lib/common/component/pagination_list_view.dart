import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/model_with_id.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter_delivery_app/common/utils/pagination_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // 매장 더보기 요청을 위한 스크롤 리스너 등록
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.pagination(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CursorPaginationBase state = ref.watch(widget.provider);

    if (state is CursorPaginationLoading) {
      // 로딩 상태
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CursorPaginationError) {
      // 에러 상태
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            child: const Text('다시시도'),
            onPressed: () {
              // 강제로 데이터 불러오기
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
          ),
        ],
      );
    }

    // CursorPagination, CursorPaginationRefetching, CursorPaginationFetchingMore 상태
    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: cp is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터입니다.'),
              ),
            );
          }

          final pItem = cp.data[index];

          // return GestureDetector(
          //   child: RestaurantCard.fromModel(model: pItem),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (_) => RestaurantDetailScreen(
          //           id: pItem.id,
          //           name: pItem.name,
          //         ),
          //       ),
          //     );
          //   },
          // );
          return widget.itemBuilder(
            context,
            index,
            pItem,
          );
        },
        separatorBuilder: (_, index) => const SizedBox(height: 16.0),
      ),
    );
  }
}
