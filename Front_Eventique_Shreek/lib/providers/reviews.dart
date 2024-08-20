import 'dart:convert';
import 'package:eventique_company_app/main.dart';
import 'package:eventique_company_app/models/one_review.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Reviews with ChangeNotifier {
  final String token;
  Reviews(this.token);
  ReviewsService reviewsService = ReviewsService();
  PdfService pdfService = PdfService();

  final Map<int, List<OneReview>> _reviewsForServiceMap = {};

  Future<void> getReviewsForService(int serviceId) async {
    final reviews = await reviewsService.fetchReviews(token, serviceId);
    _reviewsForServiceMap[serviceId] = reviews;
    notifyListeners();
  }

  List<OneReview> reviewsForService(int serviceId) {
    return _reviewsForServiceMap[serviceId] ?? [];
  }

  Future<void> downloadPdf(String fileName) async {
    pdfService.downloadPdf(fileName, token);
  }
}

class ReviewsService {
  final String apiUrl = '$host/api/reviews';

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
      final events = data['users'] as List;

      return events.map((e) {
        return OneReview(
          personName: e['name'],
          theComment: e['description'] ?? '',
          rating: (e['rate'] as num).toDouble(), // Convert rate to double
          imgurl: e['images'].isNotEmpty ? e['images'][0] : '',
          personId: e['user_id'],
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed fetchReviewsssssssssss');
    }
  }
}

class PdfService {
  Future<void> downloadPdf(String fileName, String token) async {
    final String apiUrl = '$host/api/companies/terms-and-condition/pdf';

    // Request storage permissions for Android 13+
    if (await Permission.manageExternalStorage.request().isGranted ||
        await Permission.storage.request().isGranted) {
      try {
        // Make HTTP GET request
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Accept': 'application/json',
            'locale': 'en',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Get the Downloads directory
          final downloadsDirectory = Directory('/storage/emulated/0/Download');
          if (await downloadsDirectory.exists()) {
            final filePath = '${downloadsDirectory.path}/$fileName';

            // Write the response body to a file
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            print('PDF saved to $filePath');

            // Open the PDF file
            await OpenFile.open(filePath);
          } else {
            print('Downloads directory does not exist');
          }
        } else {
          print('Failed to download PDF: ${response.statusCode}');
        }
      } catch (e) {
        print('Error downloading PDF: $e');
      }
    } else {
      print('Storage permission denied');
    }
  }
}
