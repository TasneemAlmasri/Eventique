import 'dart:convert';

import 'package:eventique_admin_dashboard/main.dart';
import 'package:eventique_admin_dashboard/models/category.dart';
import 'package:eventique_admin_dashboard/models/eventTypes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesAndTypes with ChangeNotifier {
  final String token;
  CategoriesAndTypes(this.token);

  // Categories...........................................................
  List<Category> _categories = [];
  List<Category> get categories => [..._categories];

  Future<void> fetchCategories() async {
    String apiUrl = '$host/api/categories';
    print('I am in fetchCategories');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
      },
    );
    if (response.statusCode == 200) {
      print('I am in the fetchCategories 200');
      print(response.body);
      final data = jsonDecode(response.body);
      final categoriesData = data['data'] as List;

      // Update the internal _categories list
      _categories = categoriesData.map((e) {
        return Category(id: e['id'], name: e['name']);
      }).toList();

      // Notify listeners about the change
      notifyListeners();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> addCategory(String name) async {
    print('i am in add category');
    print('token is $token');
    String apiUrl = '$host/api/admin/categories';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
        },
        body: jsonEncode({
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        print('Category added successfully');
        fetchCategories();
        notifyListeners();
      } else {
        print(response.body);
        throw Exception('Failed to add category');
      }
    } catch (error) {
      print('Error adding category: $error');
      throw error;
    }
  }

  // Event Types.................................................
  List<EventType> _eventTypes = [];
  List<EventType> get eventTypes => [..._eventTypes];

  Future<void> fetchEventTypes() async {
    String apiUrl = '$host/api/event-type';
    print('I am in fetchEventTypest');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
      },
    );
    if (response.statusCode == 200) {
      print('I am in the fetchEventTypessssssss 200');
      print(response.body);
      final data = jsonDecode(response.body);
      final eventTypesData = data['data'] as List;

      // Update the internal _eventTypes list
      _eventTypes = eventTypesData.map((e) {
        return EventType(id: e['id'], name: e['name']);
      }).toList();

      // Notify listeners about the change
      notifyListeners();
    } else {
      throw Exception('Failed to load event types');
    }
  }

  Future<void> addEventType(String name) async {
    print('i am in add addEventType and i will add $name');
    print(token);
    String apiUrl = '$host/api/event-type';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token',
          'locale': 'en',
        },
        body: jsonEncode({
          'name': name.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('addEventType added successfully');
        fetchEventTypes();
        notifyListeners();
      } else {
        print(response.body);
        throw Exception('Failed to add add event type');
      }
    } catch (error) {
      print('Error adding event type: $error');
      throw error;
    }
  }
}
