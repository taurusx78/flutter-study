import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItemModel>>(
        (ref) => ShoppingListNotifier());

// 상태 관리할 데이터의 타입은 List<ShoppingItemModel>
class ShoppingListNotifier extends StateNotifier<List<ShoppingItemModel>> {
  // StateNotifier 생성 시, 상태 관리할 데이터(state)의 초기값 지정
  ShoppingListNotifier()
      : super([
          ShoppingItemModel(
            name: '김치',
            quantity: 3,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: '라면',
            quantity: 5,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: '삼겹살',
            quantity: 10,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: '수박',
            quantity: 2,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: '카스테라',
            quantity: 5,
            hasBought: false,
            isSpicy: false,
          ),
        ]);

  void toggleHasBought({required String name}) {
    state = state
        .map((e) => e.name == name
            ? ShoppingItemModel(
                name: e.name,
                quantity: e.quantity,
                hasBought: !e.hasBought,
                isSpicy: e.isSpicy,
              )
            : e)
        .toList();
  }
}
