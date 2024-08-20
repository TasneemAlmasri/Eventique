import 'package:eventique_company_app/main.dart';
import 'package:eventique_company_app/models/one_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllServices with ChangeNotifier {
  final int companyId;
  final String token;
  AllServices(this.companyId, this.token) {
    fetchAllServices();
  }
// Provider.of<Auth>(context,listen: false).userId;

  List<OneService> _allServices = [];
  List<OneService> get allServices => [..._allServices];

  final ServicesService _servicesService = ServicesService();
  final SearchService _searchService = SearchService();

  Future<void> fetchAllServices() async {
    final fetchAllServices = await _servicesService.fetchAllServices(companyId);
    _allServices = fetchAllServices;
    notifyListeners();
  }

  Future<void> deleteService(serviceId) async {
    await _servicesService.deleteService(token, serviceId);
    fetchAllServices();
  }

  Future<void> editActivation(isVisible, serviceId) async {
    await _servicesService.editActivation(isVisible, token, serviceId);
    fetchAllServices();
  }

  OneService findById(int id) {
    return _allServices.firstWhere((element) => element.serviceId == id);
  }

// below we are handling the search
  //  List<OneService> searchResults=[];
  Future<List<OneService>> getSearchInAll(String text) async {
    final fetchAllServices = await _searchService.getSearchInAll(text, token);
    return fetchAllServices;
  }

// below we are handling tab cahnging in service details
  int _indexForBotomContent = 0;
  int get indexForBotomContent => _indexForBotomContent;

  void changeIndexforBottom(int newIndex) {
    _indexForBotomContent = newIndex;
    notifyListeners();
  }

  //taghreed
  Future<void> editService(
      List<String> imagesPicked,
      String serviceName,
      double servicePrice,
      int selectedCatId,
      String description,
      bool selectInPackages,
      int serviceId) async {
    final url = Uri.parse('$host/api/services/$serviceId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'price': servicePrice,
          'category_id': selectedCatId,
          'name': serviceName,
          'description': description,
          'images': imagesPicked,
          'discounted_packages': selectInPackages,
        }),
      );

      if (response.statusCode == 200) {
        print('I am in edit service ');
      } else {
        print(response.body);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

//.........................http................................................

class ServicesService {
  final String apiUrl1 = '$host/api/services';
  // final String apiUrl2 = '$host/api/categories/1/services';

  Future<List<OneService>> fetchAllServices(int companyId) async {
    print('companyIddddddddddddddddddd $companyId');
    final String apiUrl1 = '$host/api/companies/$companyId/services';
    final response = await http.get(
      Uri.parse(apiUrl1),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
      },
    );

    if (response.statusCode == 200) {
      print('respnse bodyyyyyyyyyyyyyyyyyyyyyyyyyyyyy${response.body}');
      final data = jsonDecode(response.body);
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
          isActivated: e['activation'] == 1,
          isDiscountedPackages: e['discounted_packages'] == 1,
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load services');
    }
  }

  //..................................
  Future<void> editActivation(
      bool isVisible, String token, int serviceId) async {
    int activation = isVisible == true ? 0 : 1;
    print('tooooooken $token so what');
    print('serviceIdddddd $serviceId ');
    final url = Uri.parse('$host/api/services/$serviceId/update-activation');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
        },
        body: {
          'activation': activation.toString(),
        },
      );

      if (response.statusCode == 200) {
        print('I am in editActivationnnnnnn 200 ');
      } else {
        print(response.body);
        print('faild in editActivation');
        throw Exception('Failed to editActivation');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteService(String token, int serviceId) async {
    print('tooooooken $token so what');
    final url = Uri.parse('$host/api/services/$serviceId/delete');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
        },
      );

      if (response.statusCode == 200) {
        print('I am in deleteServiceeeeeeeeeeeee ');
      } else {
        print(response.body);
        print('faild in deleteService');
        throw Exception('Failed to deleteService');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //  Future<void> editService(
  //   List<String> imagesPicked,
  //   String serviceName,
  //   double servicePrice,
  //   int selectedCatId,
  //   String description,
  //   bool selectInPackages,
  //   int serviceId
  //  ) async {

  //   final url = Uri.parse('$host/api/services/1/$serviceId');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         // 'Authorization': 'Bearer $token',
  //         'locale': 'en',
  //       },
  //       body: {
  //         'price':
  //         '':
  //         '':
  //         '':
  //         '':
  //         '':

  //       },
  //     );

  //     if (response.statusCode == 200) {
  //        print('I am in editActivationnnnnnn ');
  //     }
  //     else {
  //       print(response.body);
  //       print('faild in editActivation');
  //     throw Exception('Failed to editActivation');
  //   }
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }
}

class SearchService {
  final String apiUrl1 = '$host/api/search_company';

  Future<List<OneService>> getSearchInAll(String text, String token) async {
    print('I am in getSearchInAllllllllllllllll and going to get them');

    final response = await http.post(
      Uri.parse(apiUrl1),
      headers: {
        'Accept': 'application/json',
        'locale': 'en', // or 'en' depending on your requirement
        'Authorization': 'Bearer $token',
      },
      body: {'search_text': text},
    );

    if (response.statusCode == 200) {
      print('iam in getSearchInAlllllllllllllllllll 200');
      print('respnse bodyyyyyyyyyyyyyyyyyyyyyyyyyyyyy${response.body}');
      final data = jsonDecode(response.body);
      final allServices = data['services'] as List;

      return allServices.map((e) {
        List<String> imageUrls = [];
        if (e['images'] != null) {
          imageUrls = (e['images'] as List)
              .map((img) => img['url'].toString())
              .toList();
        }
        bool act = e['activation'] == 1 ? true : false;
        bool discount = e['discounted_packages'] == 1 ? true : false;

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
          isActivated: act,
          isDiscountedPackages: discount,
        );
      }).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
