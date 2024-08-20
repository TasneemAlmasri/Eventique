import 'dart:convert';
import 'dart:async'; // Add this import for debounce
import 'package:eventique/main.dart';
import 'package:eventique/models/one_review.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Reviews with ChangeNotifier {
  final String token;
  Reviews(this.token);
  Map<int, double> _currentRatings = {};
  ReviewsService reviewsService = ReviewsService();
  final Map<int, List<OneReview>> _reviewsForServiceMap = {};

  // Debounce timer
  Timer? _debounce;

  void addReview(
      int serviceId, String theComment, String imgurl, String personName) {
    // Cancel previous timer if it's still active
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        await reviewsService.addReview(
          token,
          _currentRatings[serviceId] ?? 0.0,
          theComment,
          serviceId,
        );
        await getReviewsForService(serviceId); // Refresh reviews
        _currentRatings[serviceId] = 0.0;
      } catch (error) {
        print('Failed to add review: $error');
      }
    });

    // _currentRatings[serviceId] = 0.0;
    notifyListeners(); // Notify listeners to reflect changes in the UI
  }

  void deleteReview(int serviceId, int reviewIndex) {
    // Cancel previous timer if it's still active
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        await reviewsService.deleteReview(reviewIndex, token);
        await getReviewsForService(serviceId); // Refresh reviews
      } catch (error) {
        print('Failed to delete review: $error');
      }
    });

    notifyListeners(); // Notify listeners to reflect changes in the UI
  }

  double getCurrentRating(int serviceId) {
    return _currentRatings[serviceId] ?? 0.0;
  }

  void setCurrentRating(int serviceId, double rating) {
    _currentRatings[serviceId] = rating;
    notifyListeners();
  }

  Future<void> getReviewsForService(int serviceId) async {
    try {
      final reviews = await reviewsService.fetchReviews(token, serviceId);
      _reviewsForServiceMap[serviceId] = reviews;
      notifyListeners(); // Notify listeners to reflect changes in the UI
    } catch (error) {
      print('Failed to fetch reviews: $error');
    }
  }

  List<OneReview> reviewsForService(int serviceId) {
    return _reviewsForServiceMap[serviceId] ?? [];
  }
}

class ReviewsService {
  final String apiUrl = '$host/api/reviews';

  Future<void> addReview(
      String token, double rate, String description, int serviceId) async {
    print('iam in addReviewwwwwwwww');
    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    }, body: {
      "rate": rate.toString(),
      "description": description,
      "service_id": serviceId.toString(),
    });
    if (response.statusCode == 200) {
      print('I am in the addReviewwwwwwwww 200');
    } else {
      print(response.body);
      throw Exception('Failed addReviewwwwwwwww');
    }
  }

  Future<void> deleteReview(int reviewId, String token) async {
    print('I am in deleteReviewwwwwwwwwwwww ');
    print('deleteReviewwwwwwwwwwwww  $reviewId');
    final String apiUrl = '$host/api/reviews/$reviewId';

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('I am in the deleteReviewwwwwwww 200');
    } else {
      print(response.body);
      throw Exception('Failed deleteReviewwwwwwwwwww');
    }
  }

  Future<List<OneReview>> fetchReviews(String token, int serviceId) async {
    print('I am in fetchReviewsssssssssss ');
    final String apiUrl = '$host/api/reviews/$serviceId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Successfully fetchReviewsssssssssss');
      final data = jsonDecode(response.body);
      final reviews = data['users'] as List;

      return reviews.map((e) {
        return OneReview(
          personName: e['name'],
          theComment: e['description'] ?? '',
          rating: (e['rate'] as num).toDouble(),
          imgurl: e['images'].isNotEmpty ? e['images'][0] : '',
          personId: e['user_id'],
          id: e['review'],
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed fetchReviewsssssssssss');
    }
  }
}
