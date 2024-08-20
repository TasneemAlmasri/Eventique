import 'package:eventique_company_app/providers/reviews.dart';
import 'package:eventique_company_app/widgets/one_review.dart';
import 'package:eventique_company_app/widgets/rate_with_stars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewsGrid extends StatelessWidget {
  const ReviewsGrid({super.key, required this.serviceId});
  final int serviceId;

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = Provider.of<Reviews>(context);
    
    // Trigger the data fetching when the widget is built.
    if (reviewsProvider.reviewsForService(serviceId).isEmpty) {
      reviewsProvider.getReviewsForService(serviceId);
    }

    final listOfReviews = reviewsProvider.reviewsForService(serviceId);

    return ListView.builder(
      itemCount: listOfReviews.length ,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return  OneReview(
                imgurl: listOfReviews[index ].imgurl,
                personName: listOfReviews[index ].personName,
                rating: listOfReviews[index ].rating,
                theComment: listOfReviews[index ].theComment,
                serviceId: serviceId,
                reviewIndex: index ,
                personId:listOfReviews[index ].personId
              );
      },
    );
  }
}

