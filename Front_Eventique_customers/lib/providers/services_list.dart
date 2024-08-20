import 'dart:io';

import 'package:eventique/main.dart';
import 'package:eventique/models/one_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllServices with ChangeNotifier {
  AllServices() {
    fetchCategories();
    fetchAllServices();
  }

  List<OneService> _allServices = [];
  List<OneService> get allServices => [..._allServices];

  String chosenCategory = 'All';
  List<Category> _categories = [];
  final CategoryService _categoryService = CategoryService();
  final ServicesService _servicesService = ServicesService();
  final SearchService _searchService = SearchService();

  Future<void> fetchCategories() async {
    final fetchedCategories = await _categoryService.fetchCategories();
    _categories = fetchedCategories;
    notifyListeners();
  }

  Future<void> fetchAllServices() async {
    final fetchAllServices = await _servicesService.fetchAllServices();
    _allServices = fetchAllServices;
    notifyListeners();
  }

  Future<void> fetchCategorizedServices() async {
    print('chooooosen categoryyyyyyyy $chosenCategory');
    print('i am in fetchCategorizedServices');
    final fetchCategorizedServices =
        await _servicesService.fetchCategorizedServices(_categories
            .firstWhere((element) => element.name == chosenCategory)
            .id);
    _allServices = fetchCategorizedServices;
    notifyListeners();
  }

  List<Category> get categories => [..._categories];

  void changeCategory(String newchoosedcategory) {
    // print('in change category chosenname is $newchoosedcategory and its id ${_categories
    //         .firstWhere((element) => element.name == chosenCategory)
    //         .id}');
    chosenCategory = newchoosedcategory;
    if (newchoosedcategory == 'All') {
      fetchAllServices();
    } else {
      fetchCategorizedServices();
    }

    notifyListeners();
  }

  OneService findById(int id) {
    chosenCategory = 'All';
    notifyListeners();
    return _allServices.firstWhere((element) => element.serviceId == id);
  }

  List<OneService> categorizedServices() {
    print('$chosenCategory');
    print('_allServicesssssssssssssssssss ${_allServices.length}');
    return [..._allServices];
  }

// below we are handling the search
  //  List<OneService> searchResults=[];
  Future<List<OneService>> getSearchInAll(String text) async {
    print('iam in search but noth the one belowwwwww');
    // print('${_categories.firstWhere((element) => element.name == chosenCategory).id}');
    print('gi=ot the id');
    if (chosenCategory == 'All') {
      final fetchAllServices = await _searchService.getSearchInAll(text);
      return fetchAllServices;
    } else {
      final fetchAllServices = await _searchService.getSearchInCategory(
          text,
          _categories
              .firstWhere((element) => element.name == chosenCategory)
              .id);
      return fetchAllServices;
    }
  }

// below we are handling tab cahnging in service details
  int _indexForBotomContent = 0;
  int get indexForBotomContent => _indexForBotomContent;

  void changeIndexforBottom(int newIndex) {
    _indexForBotomContent = newIndex;
    notifyListeners();
  }
}

//.........................http................................................

class CategoryService {
  final String apiUrl = '$host/api/categories';

  Future<List<Category>> fetchCategories() async {
    print('I am in fetchCategoriessssssssssssssss and going to get them');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
      },
    );
    if (response.statusCode == 200) {
      print('I am in the fetchCategoriessssssssssssss 200');
      final data = jsonDecode(response.body);
      final categories = data['data'] as List;
      return categories.map((e) {
        return Category(id: e['id'], name: e['name']);
      }).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

class ServicesService {
  final String apiUrl1 = '$host/api/services';
  // final String apiUrl2 = '$host/api/categories/1/services';

  Future<List<OneService>> fetchAllServices() async {
    print('iam in fetchAllServices');
    final response = await http.get(
      Uri.parse(apiUrl1),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final allServices = data['data'] as List;

      for (var service in allServices) {
        print('$service \nLine'); // Print each service individually
      }
      return allServices.map((e) {
        List<String> imageUrls = [];
        if (e['images'] != null) {
          imageUrls = (e['images'] as List)
              .map((img) => img['url'].toString())
              .toList();
        }

        return OneService(
          serviceId: e['id'],
          categoryId: e['category_id'],
          description: e['description'],
          imgsUrl: imageUrls,
          name: e['name'],
          price: double.parse(
              e['price'].toString()), // Ensure price is parsed as double
          rating: e['average_rating'] != null
              ? double.parse(e['average_rating'].toString())
              : null, // Ensure rating is parsed as double
          vendorName: e['company_name'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<OneService>> fetchCategorizedServices(int categoryId) async {
    final String apiUrl2 = '$host/api/categories/$categoryId/services';
    final response = await http.get(
      Uri.parse(apiUrl2),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);

      final allServices = data['data'] as List;

      return allServices.map((e) {
        List<String> imageUrls = [];
        if (e['images'] != null) {
          imageUrls = (e['images'] as List)
              .map((img) => img['url'].toString())
              .toList();
        }

        return OneService(
          serviceId: e['id'],
          categoryId: e['category_id'],
          description: e['description'],
          imgsUrl: imageUrls,
          name: e['name'],
          price: double.parse(
              e['price'].toString()), // Ensure price is parsed as double
          rating: e['average_rating'] != null
              ? double.parse(e['average_rating'].toString())
              : null, // Ensure rating is parsed as double
          vendorName: e['company_name'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
}

class SearchService {
  final String apiUrl1 = '$host/api/search/all';

  Future<List<OneService>> getSearchInAll(String text) async {
    print('I am in getSearchInAllllllllllllllll and going to get them');

    final response = await http.post(
      Uri.parse(apiUrl1),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
      },
      body: {'search_text': text},
    );

    if (response.statusCode == 200) {
      print('iam in getSearchInAlllllllllllllllllll 200');
      final data = jsonDecode(response.body);
      final allServices = data['services'] as List;

      return allServices.map((e) {
        List<String> imageUrls = [];
        if (e['images'] != null) {
          imageUrls = (e['images'] as List)
              .map((img) => img['url'].toString())
              .toList();
        }

        return OneService(
          serviceId: e['id'],
          categoryId: e['category_id'],
          description: e['description'],
          imgsUrl: imageUrls,
          name: e['name'],
          price: double.parse(
              e['price'].toString()), // Ensure price is parsed as double
          rating: e['average_rating'] != null
              ? double.parse(e['average_rating'].toString())
              : null, // Ensure rating is parsed as double
          vendorName: e['company_name'],
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load categories');
    }
  }

  Future<List<OneService>> getSearchInCategory(
      String text, int categoryId) async {
    final String apiUrl2 = '$host/api/search/$categoryId';

    print('I am in getSearchInCategory and going to get them');

    final response = await http.post(
      Uri.parse(apiUrl2),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
      },
      body: {'search_text': text},
    );

    if (response.statusCode == 200) {
      print('iam in getSearchInCategory 200');
      final data = jsonDecode(response.body);
      final allServices = data['services'] as List;

      return allServices.map((e) {
        List<String> imageUrls = [];
        if (e['images'] != null) {
          imageUrls = (e['images'] as List)
              .map((img) => img['url'].toString())
              .toList();
        }

        return OneService(
          serviceId: e['id'],
          categoryId: e['category_id'],
          description: e['description'],
          imgsUrl: imageUrls,
          name: e['name'],
          price: double.parse(
              e['price'].toString()), // Ensure price is parsed as double
          rating: e['average_rating'] != null
              ? double.parse(e['average_rating'].toString())
              : null, // Ensure rating is parsed as double
          vendorName: e['company_name'],
        );
      }).toList();
    } else {
      throw Exception('Failed to getSearchInCategory');
    }
  }
}

//.....................http model...
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}
