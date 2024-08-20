import 'package:eventique/color.dart';
import 'package:flutter/material.dart';

class VendorProfileItem extends StatelessWidget {
  String? title;
  String? subTitle;
  VendorProfileItem({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title!,
        style: const TextStyle(
          color: secondary,
          fontSize: 18,
          fontFamily: 'CENSCBK',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subTitle!,
        style: const TextStyle(
          color: primary,
          fontSize: 16,
          fontFamily: 'CENSCBK',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
