import 'dart:convert';

import 'package:eventique_admin_dashboard/main.dart';
import 'package:eventique_admin_dashboard/models/one_service.dart';
import 'package:eventique_admin_dashboard/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Packages with ChangeNotifier {
  final String token;
  Packages(this.token);

  List<Package> _availablePackages = [];
  List<OneService> _packageServices = [];
  List<OneService> _packagableServices = [];
  List<Package> get availablePackages => [..._availablePackages];
  List<OneService> get packagableServices => [..._packagableServices];
  List<OneService> get packageServices => [..._packageServices];

  Future<void> fetchAvailablePackages() async {
  final url = Uri.parse('$host/api/packages');
  print('I am in fetchAvailablePackages');
  try {
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'locale': 'en',
    });
    print('Response: ${response.body}');
    final responseData = json.decode(response.body);
    print('Response Data: $responseData');

    final packages = responseData['data'];
    final List<Package> temp = [];
    packages.forEach((package) {
      print('Processing package: $package');

      // Only fetch package-level details
      temp.add(Package(
        id: package['id'],
        name: package['name'],
        oldPrice: (package['old_price'] as num).toDouble(),
        newPrice: (package['new_price'] as num).toDouble(),
        packageServices: [], // Leave services empty for now
      ));
    });
    print('Temporary packages list length: ${temp.length}');
    _availablePackages = temp;
    notifyListeners();
  } catch (error) {
    print('Error occurred: $error');
    throw error;
  }
}
  
  Future<void> fetchServicesInPackage(int packageId) async {
  print('I am in fetchServicesInPackage');
  final url = Uri.parse('$host/api/packages/$packageId');
  print(url);
  try {
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
      },
    );
    final responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    // Extract services from the package data
    final packageData = responseData['data'];
    final services = packageData['services'];
    final List<OneService> temp = [];

    services.forEach((service) {
      // Extract image URLs from the images array
      List<String> imageUrls = [];
      if (service['images'] != null) {
        service['images'].forEach((image) {
          imageUrls.add(image['url']);
        });
      }

      temp.add(OneService(
        serviceId: service['id'],
        categoryId: service['category_id'],
        name: service['name'],
        rating: service['average_rating'] != null
            ? (service['average_rating'] as num).toDouble()
            : null,
        vendorName: service['company_name'],
        imgsUrl: imageUrls, // Set the image URLs
        price: (service['price'] as num).toDouble(),
        description: service['description'],
      ));
    });

    _packageServices = temp;
    notifyListeners();
  } catch (error) {
    print(error);
    throw error;
  }
}



  Future<void> fetchPackagableServices() async {
    print('I am in fetchPackagableServices');
    final url = Uri.parse('$host/api/packages/services/packagable');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'locale': 'en',
        },
      );
      final responseData = json.decode(response.body);
      print(response.body);
      print(response.statusCode);
      final services = responseData['data'];
      final List<OneService> temp = [];

      services.forEach((service) {
        // Extract image URLs from the images array
        List<String> imageUrls = [];
        if (service['images'] != null) {
          service['images'].forEach((image) {
            imageUrls.add(image['url']);
          });
        }

        temp.add(OneService(
          serviceId: service['id'],
          categoryId: service['category_id'],
          name: service['name'],
          rating: service['average_rating'] != null
              ? (service['average_rating'] as num).toDouble()
              : null,
          vendorName: service['company_name'],
          imgsUrl: imageUrls, // Set the image URLs
          price: (service['price'] as num).toDouble(),
          description: service['description'],
        ));
      });

      _packagableServices = temp;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }


//   Future<void> deleteService(int packageId, int serviceId) async {
//   print('I am in deleteService');
//   final url = Uri.parse('$host/api/packages/$packageId');
//   print(url);

//   try {
//     final response = await http.delete(
//       url,
//       headers: {
//         'Accept': 'application/json',
//         'locale': 'en',
//         'Content-Type': 'application/json',  // Set content type to JSON
//       },
//       body: json.encode({
//         'delete_services': serviceId  // Assuming backend expects this format
//       }),
//     );

//     print(response.body);
//     print(response.statusCode);

//     if (response.statusCode == 200) {
//       // Successfully deleted
//       notifyListeners();  // Notify listeners to update the state
//     } else {
//       // Handle error or unexpected status code
//       throw Exception('Failed to delete service. Status code: ${response.statusCode}');
//     }
//   } catch (error) {
//     print(error);
//     throw error;
//   }
// }

  Future<void> deletePackage(int packageId) async {
    print('I am in deleteService');
    final url = Uri.parse('$host/api/packages/$packageId');
    print(url);

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'locale': 'en',
          'Content-Type': 'application/json', // Set content type to JSON
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Update the list of available packages
        _availablePackages.removeWhere((package) => package.id == packageId);

        notifyListeners(); // Notify listeners to update the UI
      } else {
        throw Exception('Failed to delete package');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createPackage(
      int eventTypeId, List<int> packagableServices) async {
    print(
        'I am in createPackage and eventId is $eventTypeId, and serv is $packagableServices');
    final url = Uri.parse('$host/api/packages');

    try {
      // Convert list of service IDs to a list of objects with "id" as key
      List<Map<String, int>> servicesList = packagableServices.map((serviceId) {
        return {'id': serviceId};
      }).toList();

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Ensure content type is JSON
          'locale': 'en',
        },
        body: jsonEncode({
          // Encode the entire body as JSON
          'event_type_id': eventTypeId,
          'services': servicesList, // Send the list of objects
          'image': 'no', // This field must also be sent
        }),
      );

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        fetchAvailablePackages();

        notifyListeners(); // Notify listeners to update the UI
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
