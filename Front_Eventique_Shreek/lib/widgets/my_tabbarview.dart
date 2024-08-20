import '/widgets/description.dart';
import '/widgets/reviews_grid.dart';
import 'package:flutter/material.dart';

class MyTabBarView extends StatelessWidget {
  const MyTabBarView(
      {super.key,
      required this.tabController,
      required this.serviceId,
      required this.description,
      required this.price,
      required this.category,
      required this.isVisisble,
      required this.isDiscounted});
  final TabController tabController;
  final int serviceId;
  final String description, category;
  final double price;
  final bool isVisisble, isDiscounted;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        // Tab 1 content
        ListView(
          padding: EdgeInsets.all(0),
          children: [
            Description(
              description: description,
              price: price,
              category: category,
              isDiscounted: isDiscounted,
              isVisisble: isVisisble,
              serviceId: serviceId,
            ),
          ],
        ),
        // Tab 2 content
        ReviewsGrid(serviceId: serviceId),
      ],
    );
  }
}
