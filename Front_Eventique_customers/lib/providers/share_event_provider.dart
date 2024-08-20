import 'dart:convert';

import 'package:eventique/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShareEventProvider with ChangeNotifier {
  final String token;
  ShareEventProvider(this.token);

  Future<void> shareEvent(
      int id, String description, List<String> imgsUrls) async {
    final url = Uri.parse('$host/api/shares');
    print(url);
    print(token);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "event_id": id,
          "description": description,
          "images": imgsUrls,
        }),
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData == null) {
        throw Exception();
      }
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
