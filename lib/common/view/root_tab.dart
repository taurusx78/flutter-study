import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with TickerProviderStateMixin {
  late TabController tabController;

  int index = 0; // 현재 BottomNavigation 인덱스

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코펙 딜리버리',
      child: TabBarView(
        // 좌우 스와이프 방지
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          RestaurantScreen(),
          Center(child: Text('음식')),
          Center(child: Text('주문')),
          Center(child: Text('프로필')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (index) {
          // 선택된 인덱스에 해당하는 Tab 화면으로 이동
          tabController.animateTo(index);
          setState(() {
            this.index = tabController.index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
