//changes to find error
//commented tab 2

import 'package:eventique/providers/services_list.dart';
import 'package:eventique/widgets/description.dart';
import 'package:eventique/widgets/quantity_selector.dart';
import 'package:eventique/widgets/reviews_grid.dart';
import 'package:eventique/widgets/vendor_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTabBarView extends StatelessWidget {
  const MyTabBarView({
    super.key,
    required this.tabController,
    required this.serviceId,
    required this.description,
    required this.vendorname,
    required this.serviceCategoryId,
  });
  final TabController tabController;
  final int serviceId, serviceCategoryId;
  final String description;
  final String vendorname;

  @override
  Widget build(BuildContext context) {
    final allServices = Provider.of<AllServices>(context);
    final categories = allServices.categories;
    final String categoryName = categories
        .firstWhere((element) => element.id == serviceCategoryId)
        .name;

    return TabBarView(
      controller: tabController,
      children: [
        // Tab 1 content
        ListView(
          padding: EdgeInsets.all(0),
          children: [
            VendorTile(
              vendorname: vendorname,
            ),
            (categoryName != 'venue' &&
                    categoryName != 'photography' &&
                    categoryName != 'transportation')
                ? QuantitySelector(serviceId: serviceId)
                : Container(),
            Description(
              description: description,
            ),
          ],
        ),
        // Tab 2 content
        ReviewsGrid(
          serviceId: serviceId,
        ),
      ],
    );
  }
}
