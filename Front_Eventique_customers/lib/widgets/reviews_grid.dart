import 'package:eventique/widgets/one_review.dart';
import 'package:eventique/widgets/rate_with_stars.dart';
import 'package:eventique/providers/reviews.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewsGrid extends StatefulWidget {
  const ReviewsGrid({super.key, required this.serviceId});
  final int serviceId;

  @override
  _ReviewsGridState createState() => _ReviewsGridState();
}

class _ReviewsGridState extends State<ReviewsGrid> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger data fetching here
    final reviewsProvider = Provider.of<Reviews>(context);
    if (reviewsProvider.reviewsForService(widget.serviceId).isEmpty) {
      reviewsProvider.getReviewsForService(widget.serviceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = Provider.of<Reviews>(context);
    final listOfReviews = reviewsProvider.reviewsForService(widget.serviceId);

    return ListView.builder(
      itemCount: listOfReviews.length + 1,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return (index == 0)
            ? RateWithStars(serviceId: widget.serviceId)
            : OneReview(
                imgurl: listOfReviews[index - 1].imgurl,
                personName: listOfReviews[index - 1].personName,
                rating: listOfReviews[index - 1].rating,
                theComment: listOfReviews[index - 1].theComment,
                serviceId: widget.serviceId,
                reviewIndex: listOfReviews[index - 1].id,
                personId: listOfReviews[index - 1].personId,
              );
      },
    );
  }
}
