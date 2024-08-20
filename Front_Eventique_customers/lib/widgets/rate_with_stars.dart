import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:eventique/providers/reviews.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RateWithStars extends StatefulWidget {
  const RateWithStars({super.key, required this.serviceId});
  final int serviceId;

  @override
  _RateWithStarsState createState() => _RateWithStarsState();
}

class _RateWithStarsState extends State<RateWithStars> {
  // double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<Reviews>(context);
    var ratingfromPro = reviewProvider.getCurrentRating(widget.serviceId);
    return Padding(
      padding: const EdgeInsets.only(left: 34, bottom: 24,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate this service',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
          ),
          RatingBar.builder(
            initialRating: ratingfromPro,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Color(0xffEBC25C),
            ),
            onRatingUpdate: (rating) {
              setState(() {
                ratingfromPro = rating;
              });
              reviewProvider.setCurrentRating(widget.serviceId,ratingfromPro);
            },
            updateOnDrag: true,
            itemSize: 24,
            unratedColor: Color.fromARGB(255, 207, 207, 207),
          ),
        ],
      ),
    );
  }
}
