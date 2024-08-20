import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateWithStars extends StatelessWidget {
  final double serviceRating;

  RateWithStars({required this.serviceRating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: serviceRating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Color(0xffEBC25C),
      ),
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemSize: 24,
      unratedColor: Color.fromARGB(255, 207, 207, 207),
    );
  }
}
