import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';

class PaginationUtils {
  // 현재 위치가 최대 길이 위치에 근접하다면 추가 데이터 요청
  static void pagination({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    // controller.offset: 스크롤 현재 위치
    // controller.position.maxScrollExtent: 최대로 스크롤 가능한 길이
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true);
    }
  }
}
