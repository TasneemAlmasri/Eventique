//chanf=ges to find erro
// commented  // Tab(
//   child: Text(
//     'Reviews',
//     style: TextStyle(fontFamily: 'IrishGrover', fontSize: 20),
//   ),
// ),

import '/color.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        tabBar: TabBar(
          labelColor: primary,
          controller: tabController,
          dividerColor: const Color(0xffEFEEEA),
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(6),
          unselectedLabelColor: const Color(0xffE791A5),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFFFFDF0),
          ),
          tabs: const [
            Tab(
              child: Text(
                'Details',
                style: TextStyle(fontFamily: 'IrishGrover', fontSize: 20),
              ),
            ),
            Tab(
              child: Text(
                'Reviews',
                style: TextStyle(fontFamily: 'IrishGrover', fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate({required this.tabBar});

  @override
  double get minExtent =>
      85; // 55 container and 20 margin on bottom 10 margin top
  @override
  double get maxExtent => 85;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: const Color(0xFFFFFDF0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(
          color: const Color(0xffEFEEEA),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Align(
          alignment: Alignment.center,
          child: tabBar,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false; // No need to rebuild unless the TabBar changes
  }
}
