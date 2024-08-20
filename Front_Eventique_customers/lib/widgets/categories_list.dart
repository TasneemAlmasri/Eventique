//the tags in vendors (services)screen
import 'package:eventique/providers/services_list.dart';
import 'package:eventique/widgets/category_tag_chip.dart';
import 'package:eventique/models/one_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<Color> colors = [
  Color(0XffF9EAE3),
  Color(0XffFFFADC),
  Color(0XffEDFCEA),
  Color(0XffFAF6F2),
  Color(0XffEEFAFF),
  Color(0XffFFCFDA)
];

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final allServices = Provider.of<AllServices>(context);
    final categories = allServices.categories;

    return Container(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // one for the 'All' category
        itemBuilder: (context, index) {
          if (index == 0) {
            return CategoryTag(
              title: 'All',
              color: Color(0XffFFE0D3),
            );
          } else {
            int categoryIndex = index - 1;
            final category = categories[categoryIndex];
            return CategoryTag(
              title: category.name, // use the category name
              color: colors[categoryIndex % colors.length],
            );
          }
        },
      ),
    );
  }
}
