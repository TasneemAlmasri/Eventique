import 'package:eventique/providers/services_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTag extends StatelessWidget {
  final String title;
  final Color color;

  const CategoryTag({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    //theme
    final TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;

    bool isSelected = Provider.of<AllServices>(context).chosenCategory == title;

    return GestureDetector(
      onTap: () {
        Provider.of<AllServices>(context, listen: false).changeCategory(title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xff662465),
            width: 0.5,
          ),
          color: isSelected ? const Color(0xff662465) : color,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodySmallStyle!.copyWith(
                fontFamily: 'IrishGrover',
                color: isSelected
                    ? const Color(0xFFFFFDF0)
                    : const Color(0xff662465)),
          ),
        ),
      ),
    );
  }
}
