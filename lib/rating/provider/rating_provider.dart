import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter_delivery_app/rating/model/rating_model.dart';
import 'package:flutter_delivery_app/rating/repository/rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratingProvider = StateNotifierProvider.family<RatingStateNotifier,
    CursorPaginationBase, String>((ref, id) {
  final repository = ref.watch(ratingRepositoryProvider(id));
  final notifier = RatingStateNotifier(repository: repository);
  return notifier;
});

class RatingStateNotifier
    extends PaginationStateNotifier<RatingModel, RatingRepository> {
  RatingStateNotifier({
    required repository,
  }) : super(repository: repository);
}
