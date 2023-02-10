import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/utils/pagination_utils.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/rating/component/rating_card.dart';
import 'package:flutter_delivery_app/rating/model/rating_model.dart';
import 'package:flutter_delivery_app/rating/provider/rating_provider.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id; // 매장 id
  final String name; // 매장명

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // 매장 상세 데이터 요청
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    // 리뷰 더보기 요청을 위한 스크롤 리스너 등록
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.pagination(
      controller: controller,
      provider: ref.read(ratingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RestaurantModel? state =
        ref.watch(restaurantDetailProvider(widget.id));
    // 매장 리뷰 데이터 가져오기
    final CursorPaginationBase ratingsState =
        ref.watch(ratingProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: widget.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel('메뉴'),
          if (state is RestaurantDetailModel)
            renderProducts(products: state.products),
          if (ratingsState is CursorPagination<RatingModel>) renderLabel('리뷰'),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(ratings: ratingsState.data, state: ratingsState),
        ],
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel(String title) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<ProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
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

  SliverPadding renderRatings({
    required List<RatingModel> ratings,
    required CursorPaginationBase state,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == ratings.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: state is CursorPaginationFetchingMore
                      ? const CircularProgressIndicator()
                      : const Text('마지막 리뷰입니다.'),
                ),
              );
            }

            final rating = ratings[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: RatingCard.fromModel(model: rating),
            );
          },
          childCount: ratings.length + 1,
        ),
      ),
    );
  }
}
