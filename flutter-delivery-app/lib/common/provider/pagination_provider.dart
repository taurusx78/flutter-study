import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/model_with_id.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_delivery_app/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PaginationParams {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationParams({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationStateNotifier<T extends IModelWithId,
        U extends IBasePaginationRepository>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final throttle = Throttle(
    const Duration(seconds: 2),
    initialValue: _PaginationParams(),
    // true - Throttle을 실행할 때 입력하는 value 값이 똑같으면 Throttle 적용하지 않음
    checkEquality: false,
  );

  PaginationStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();

    // setValue() 함수가 실행되면 listen() 함수가 실행됨
    // event: 맨 첫 값은 initialValue 값을, 이후 setValue() 파라미터에 입력되는 값을 가짐
    throttle.values.listen((event) {
      _throttlePaginate(event);
    });
  }

  Future<void> paginate({
    // 가져올 데이터 수
    int fetchCount = 20,
    // 더보기 요청 여부
    // - true: 추가로 데이터 더 가져옴
    // - false: 새로고침 (화면에 노출된 기존 데이터 유지한 상태 - CursorPaginationRefetching)
    bool fetchMore = false,
    // 강제 새로고침 여부
    // - true: 새로고침 (화면에 노출된 기존 데이터 비운 상태 - CursorPaginationLoading)
    bool forceRefetch = false,
  }) async {
    // Throttle 적용
    throttle.setValue(_PaginationParams(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  _throttlePaginate(_PaginationParams params) async {
    final fetchCount = params.fetchCount;
    final fetchMore = params.fetchMore;
    final forceRefetch = params.forceRefetch;

    try {
      // [바로 반환되는 경우]
      // 1) 추가로 가져올 수 있는 데이터가 없는 경우 (hasMore = false)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2) 로딩중인 상태에서 더보기를 요청한 경우
      if ((isLoading || isRefetching || isFetchingMore) && fetchMore) {
        return;
      }

      // [5가지 상태]
      // 1) CursorPagination - 데이터가 있는 상태
      // 2) CursorPaginationLoading - 로딩 상태 (캐시 없음)
      // 3) CursorPaginationError - 에러 상태
      // 4) CursorPaginationRefetching - 새로고침 상태 (캐시 있음)
      // 5) CursorPaginationFetchingMore - 더보기 요청 상태

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      if (fetchMore) {
        // 데이터를 추가로 가져오는 경우 (5)
        final pState = state as CursorPagination<T>;

        // CursorPaginationFetchingMore 상태로 변경
        state = CursorPaginationFetchingMore<T>(
          meta: pState.meta,
          data: pState.data,
        );

        // 쿼리스트링 after 값 변경
        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      } else {
        // 데이터를 처음부터 가져오는 경우
        if (state is CursorPagination && !forceRefetch) {
          // 기존 데이터가 있을 때 캐시 유지한 채로 새로고침 (4)
          final pState = state as CursorPagination<T>;

          // CursorPaginationRefetching 상태로 변경
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // 데이터 없는 상태에서의 새로고침 (2)
          // CursorPaginationLoading 상태로 변경
          state = CursorPaginationLoading();
        }
      }

      // 요청 후 응답받기 (CursorPagination 타입의 데이터)
      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        final pResp = resp as CursorPagination<T>;

        // CursorPagination 상태로 변경 및 가져온 데이터 추가
        state = pResp.copyWith(
          data: [
            ...pState.data,
            ...pResp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      print('에러 발생');
      print(e);
      // 에러가 난 경우 (3)
      // CursorPaginationError 상태로 변경
      state =
          CursorPaginationError(message: '예기치 못한 오류가 발생했습니다.\n잠시후 다시 시도해 주세요.');
    }
  }
}
