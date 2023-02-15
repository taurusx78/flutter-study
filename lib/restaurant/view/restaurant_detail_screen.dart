import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/utils/pagination_utils.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/product/model/product_model.dart';
import 'package:flutter_delivery_app/rating/component/rating_card.dart';
import 'package:flutter_delivery_app/rating/model/rating_model.dart';
import 'package:flutter_delivery_app/rating/provider/rating_provider.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_delivery_app/restaurant/view/basket_screen.dart';
import 'package:flutter_delivery_app/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

  final String id; // 매장 id

  const RestaurantDetailScreen({
    required this.id,
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
    // 상품 카운트 가져오기
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: state.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel('메뉴'),
          if (state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>) renderLabel('리뷰'),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(ratings: ratingsState.data, state: ratingsState),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
          badgeContent: Text(
            basket
                .fold<int>(0, (previous, next) => previous + next.count)
                .toString(),
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10.0,
            ),
          ),
          child: const Icon(Icons.shopping_basket_outlined),
        ),
        onPressed: () {
          // 장바구니 페이지로 이동
          context.pushNamed(BasketScreen.routeName);
        },
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
    required List<RestaurantProductModel> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];

            return InkWell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ProductCard.fromRestaurantProductModel(model: product),
              ),
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        id: product.id,
                        name: product.name,
                        detail: product.detail,
                        imgUrl: product.imgUrl,
                        price: product.price,
                        restaurant: restaurant,
                      ),
                    );
              },
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
