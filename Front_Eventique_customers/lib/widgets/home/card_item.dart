//noor
// ignore_for_file: public_member_api_docs, sort_constructors_first
import '/color.dart';
import 'package:flutter/cupertino.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    // required this.height,
    // required this.width,
    required this.firsttext,
    required this.secondtext,
    required this.image,
  }) : super(key: key);
  // final double height;
  // final double width;
  final String firsttext;
  final String secondtext;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      // width: width,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 232, 227, 249),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("$image"),
            Text(
              firsttext,
              style: TextStyle(
                  color: primary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              secondtext,
              style: TextStyle(color: primary, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
