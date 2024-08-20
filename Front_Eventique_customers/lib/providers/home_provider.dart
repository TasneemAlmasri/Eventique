import 'package:eventique/main.dart';
import 'package:eventique/models/one_service.dart';
import 'package:eventique/models/package_model.dart';
import 'package:eventique/models/you_and_us_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeProvider with ChangeNotifier {
  HomeProvider(){
    fetchPackages();
    fetchYouAndUs();
  }
  List<Package> _packages = [];
  List<YouAndUs> _youAndUs = [];
  YouAndUs _oneYouAndUs = YouAndUs();

  //packages
  List<Package> get allPackages {
    return [..._packages];
  }

  Package findPackageById(int id) {
    return _packages.firstWhere((element) => element.id == id);
  }

  //you and us
  List<YouAndUs> get allYouAndUs {
    return [..._youAndUs];
  }

  // YouAndUs findYouAndUsById(int id) {
  //   return _youAndUs.firstWhere((element) => element.id == id);
  // }

  YouAndUs get oneYourAndUs {
    return _oneYouAndUs;
  }

  Future<void> findYouAndUsById(int id) async {
    final url = Uri.parse('$host/api/shares/$id');
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
      print(responseData);
      final oneYouAndUs = responseData;

      // Check for null before parsing
      if (oneYouAndUs == null) {
        throw Exception("Data not found");
      }

      List<String> imageUrls = [];
      if (oneYouAndUs['images'] != null) {
        oneYouAndUs['images'].forEach((image) {
          imageUrls.add(image['url']);
        });
      }

      List<OneService> fetchedServices = [];
      if (oneYouAndUs['services'] != null) {
        oneYouAndUs['services'].forEach((service) {
          List<String> serviceImageUrls = [];
          if (service['images'] != null) {
            service['images'].forEach((image) {
              serviceImageUrls.add(image['url']);
            });
          }

          fetchedServices.add(OneService(
            serviceId: service['id'], // Use 'id' directly from service object
            categoryId: service['category_id'],
            name: service['name'] ?? '', // Handle potential null value
            rating: service['rating'] != null
                ? service['rating'].toDouble()
                : 0.0, // Convert to double
            vendorName:
                service['company_name'] , // Handle potential null value
            imgsUrl: serviceImageUrls,
            price: service['price'] != null
                ? service['price'].toDouble()
                : 0.0, // Convert to double
            description: service['description'] ??
                '', // Handle potential null value
          ));
        });
      }

      YouAndUs eventDetails = YouAndUs(
        id: oneYouAndUs['id'] ?? 0, // Handle potential null value
        description:
            oneYouAndUs['description'] ?? '', // Handle potential null value
        imagesUrl: imageUrls,
        eventServices: fetchedServices,
      );
      print('Fetched event details: $eventDetails');
      _oneYouAndUs = eventDetails;
      notifyListeners(); // Notify listeners about the update
    } catch (error) {
      print(error);
      throw error;
    }
  }

//fetch all packages from backend
//very basic may need edit
  Future<void> fetchPackages() async {
    final url = Uri.parse('$host/api/packages');
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
      printFullJson(
          responseData); // Use custom print function to print full JSON

      final packages = responseData['data'];
      final List<Package> temp = [];
      packages.forEach((package) {
        List<OneService> fetchedServices = [];
        if (package['services'] != null) {
          package['services'].forEach((service) {
            List<String> serviceImageUrls = [];
            if (service['images'] != null) {
              service['images'].forEach((image) {
                serviceImageUrls.add(image['url']);
              });
            }

            fetchedServices.add(OneService(
              serviceId: service['id'],
              categoryId: service['category_id'],
              name: service['name'],
              rating: (service['average_rating'] as num?)
                  ?.toDouble(), // Proper type casting
              vendorName: service['company_name'],
              imgsUrl: serviceImageUrls,
              price:
                  (service['price'] as num).toDouble(), // Proper type casting
              description: service['description'],
            ));
          });
        }

        temp.add(Package(
          id: package['id'],
          name: package['name'],
          oldPrice:
              (package['old_price'] as num).toDouble(), // Proper type casting
          newPrice:
              (package['new_price'] as num).toDouble(), // Proper type casting
          packageServices: fetchedServices,
        ));
      });
      print('this is temp packages:$temp');
      _packages = temp;
      print('this is packages which will i will see:$_packages');
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void printFullJson(dynamic json) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    print(encoder.convert(json));
  }

//fetch all you and us fromm backend
  Future<void> fetchYouAndUs() async {
    final url = Uri.parse('$host/api/shares');
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
      // Print the response in chunks
      const chunkSize = 800;
      String responseBody = response.body;
      for (int i = 0; i < responseBody.length; i += chunkSize) {
        print(responseBody.substring(
            i,
            i + chunkSize > responseBody.length
                ? responseBody.length
                : i + chunkSize));
      }
      print(responseData);
      final youAndUsList = responseData['data'];
      final List<YouAndUs> temp = [];
      youAndUsList.forEach((element) {
        List<String> imageUrls = [];
        element['images'].forEach((image) {
          imageUrls.add(image['url']);
        });

        List<OneService> fetchedServices = [];
        if (element['services'] != null) {
          element['services'].forEach((service) {
            List<String> serviceImageUrls = [];
            if (service['images'] != null) {
              service['images'].forEach((image) {
                serviceImageUrls.add(image['url']);
              });
            }

            fetchedServices.add(OneService(
              serviceId: service['service_id'],
              categoryId: service['category_id'],
              name: service['name'],
              rating: service['rating'],
              vendorName: service['vendorName'],
              imgsUrl: serviceImageUrls,
              price: service['price'],
              description: service['description'],
            ));
          });
        }

        temp.add(
          YouAndUs(
              id: element['id'],
              description: element['description'],
              imagesUrl: imageUrls,
              eventServices: fetchedServices),
        );
      });
      print('this is temp shares:$temp');
      _youAndUs = temp;
      print('this is you and us will showed:$_youAndUs');
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
