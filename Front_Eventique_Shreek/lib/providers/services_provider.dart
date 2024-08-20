import 'package:eventique_company_app/models/serviceCategory_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/main.dart';
import 'dart:convert';

class ServiceProvider with ChangeNotifier {
  final String token;
  final int id;
  ServiceProvider(this.token, this.id);
  List<ServiceCategory> _servicesCategories = [
    ServiceCategory(id: 0, category: 'Flowers'),
    ServiceCategory(id: 1, category: 'Cake')
  ];

  List<ServiceCategory> get allCategories {
    return [..._servicesCategories];
  }

  Future<void> getCategories() async {
    final url = Uri.parse('$host/api/categories');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
      },
    );
    final responseData = json.decode(response.body);
    print(responseData['data']);

    // Directly access the 'data' key and iterate over the list
    final categories = responseData['data'] as List<dynamic>;
    print(categories);
    final List<ServiceCategory> temp = [];
    categories.forEach((category) {
      temp.add(ServiceCategory(
        id: category['id'],
        category: category['name'],
      ));
    });
    // print(temp);
    _servicesCategories = temp;
    print('categories in provider:$_servicesCategories');
    notifyListeners();
  }

  Future<void> addNewService(
    List<String> imagesPicked,
    String serviceName,
    double servicePrice,
    int selectedCat,
    String description,
    bool selectInPackages,
  ) async {
    final url = Uri.parse('$host/api/services');
    print(url);
    print(token);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
          'Content-Type': 'application/json', // Added Content-Type header
        },
        body: jsonEncode({
          'name': serviceName,
          'description': description,
          'images': imagesPicked,
          'price': servicePrice,
          'category_id': selectedCat,
          'discounted_packages': selectInPackages,
          'company_id': id,
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
