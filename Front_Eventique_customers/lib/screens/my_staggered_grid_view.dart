//noor
import 'package:eventique/providers/home_provider.dart';
import 'package:provider/provider.dart';

import '/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyStaggeredGridView extends StatelessWidget {
  final int packageId;
  MyStaggeredGridView({required this.packageId});
  @override
  Widget build(BuildContext context) {
    final packageData =
        Provider.of<HomeProvider>(context).findPackageById(packageId);
    final packageServices = packageData.packageServices;
    return MasonryGridView.count(
      padding: EdgeInsets.all(10.0),
      crossAxisCount: 2,
      mainAxisSpacing: 18.0,
      crossAxisSpacing: 12.0,
      itemCount: packageServices!.length,
      itemBuilder: (context, i) => ItemCard(
        color: Color.fromARGB(255, 212, 211, 212),
        height: 286.14,
        width: 178.08,
        firsttext: packageServices[i].name,
        secondtext: packageServices[i].vendorName,
        image: packageServices[i].imgsUrl![0],
        serviceId: packageServices[i].serviceId,
      ),
    );
  }
}
