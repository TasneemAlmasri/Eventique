import 'dart:convert';

import 'package:eventique/main.dart';
import 'package:eventique/models/one_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Saved with ChangeNotifier {
  String token;
  Saved(this.token) {
    // fetchSaved();
  }
  List<OneService> _savedServices = [];
  final SavedService _service = SavedService();

  List<OneService> get savedServices => [..._savedServices];

  bool containsService(int id) {
  return _savedServices.any((element) => element.serviceId == id);
}


   Future<void> fetchSaved() async {
    try {
      final fetchedServices = await _service.fetchSaved(token);
      _savedServices = fetchedServices;
      notifyListeners();
    } catch (e) {
      // Handle fetch error
      print(e);
    }
  }

  Future<void> add(int serviceId) async {
    try {
      await _service.addSaved(serviceId, token);
      await fetchSaved(); // Ensure the local list is updated
    } catch (e) {
      // Handle add error
      print(e);
    }
  }

   Future<void> delete(int serviceId) async {
    try {
      await _service.deleteSaved(serviceId, token);
      await fetchSaved(); // Ensure the local list is updated
    } catch (e) {
      // Handle delete error
      print(e);
    }
  }
}

class SavedService {
  final String apiUrl = '$host/api/favorites';

  Future<void> addSaved(int serviceId, String token) async {
    print('I am in addSavedddddddddddddd ');

    final response = await http.post(
      Uri.parse(apiUrl),
    headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    }, body: {
      'service_id': serviceId.toString(),
    });
    if (response.statusCode == 200) {
      print('I am in the addSavedddddddddddddd 200');
    } else {
      print(response.body);
      throw Exception('Failed addSavedddddddddddddd');
    }
  }

  Future<void> deleteSaved(int serviceId, String token) async {
    final String apiUrl ='$host/api/favorites/$serviceId';
    print('I am in deleteSaveddddddddd ');

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('I am in the deleteSaveddddddddddddd 200');
    } else {
      print(response.body);
      throw Exception('Failed deleteSaveddddddddddddd');
    }
  }

 Future<List<OneService>> fetchSaved(String token) async {
  print('I am in fetchSaved and going to get them');
  print('tokeeeeeeeeeeeeen is $token');

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('I am in fetchSaved 200');
    final data = jsonDecode(response.body);
    final allServices = (data['data'] ?? []) as List;

    return allServices.map((e) {
      final service = e['service'];
      List<String> imageUrls = [];
      if (service['images'] != null) {
        imageUrls = (service['images'] as List)
            .map((img) => img['url'].toString())
            .toList();
      }

      return OneService(
        serviceId: service['id'],
        categoryId: service['category_id'],
        description: service['description'],
        imgsUrl: imageUrls,
        name: service['name'],
        price: double.parse(service['price'].toString()), // Ensure price is parsed as double
        rating: service['average_rating'] != null
            ? double.parse(service['average_rating'].toString())
            : null, // Ensure rating is parsed as double
        vendorName: service['company_name'],
      );
    }).toList();
  } else {
    print(response.body);
    throw Exception('Failed to load fetchSaved');
  }
}

}
