import 'package:eventique/widgets/categories_list.dart';
import 'package:eventique/widgets/search_bar.dart';
import 'package:eventique/widgets/services_grid.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class VendorsScreen extends StatelessWidget {
  const VendorsScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          //notifivation icon
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFFDF0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xff662465),
              ),
              onPressed: () {},
              padding: const EdgeInsets.only(bottom: 2),
            ),
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              padding: const EdgeInsets.only(left: 30),
              icon: const Icon(
                Typicons.th_menu_outline,
                color: Color(0xffDD8CA1),
                size: 28,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: const Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MySearchBar(),
            const CategoriesList(),
            ServicesGrid(),
          ],
        ),
      ),
    );
  }
}
