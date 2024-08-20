// import 'package:eventique/models/service_in_order_details.dart';
// import 'package:flutter/material.dart';

// class AcceptedServicesPro with ChangeNotifier{
// final List<ServiceInOrderDetails> services=[
//    ServiceInOrderDetails(
//     imgUrl: 'https://cdn.pixabay.com/photo/2016/10/25/13/29/smoked-salmon-salad-1768890_1280.jpg',
//     name:'red velvet' ,
//     orderServiceId: 2,
//     quantity:4 ,
//     status: Status.accepted,
//     totalPrice: 53,
//   ),
//    ServiceInOrderDetails(
//     imgUrl:  'https://i.postimg.cc/y6rkV8QR/photo-2024-04-25-23-30-27.jpg',
//     name: 'Dream Cake',
//     orderServiceId:3 ,
//     quantity: 1,
//     status: Status.accepted,
//     totalPrice: 43,
//   ),
//    ServiceInOrderDetails(
//     imgUrl: 'https://i.postimg.cc/jSD6s14x/photo-2024-04-25-23-30-29.jpg',
//     name: 'salad',
//     orderServiceId:4 ,
//     quantity: 3,
//     status: Status.accepted,
//     totalPrice:24 ,
//   )
// ];

// double getTotalPriceOfAcceptedServices() {
//     double total = 0.0;
//     for (var service in services) {
//       if (service.status == Status.accepted) {
//         total += service.totalPrice;
//       }
//     }
//     return total;
//   }

// }

import 'dart:convert';

import 'package:eventique/main.dart';
import 'package:eventique/models/service_in_order_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AcceptedServicesPro with ChangeNotifier {
  final String token;
  AcceptedServicesPro(this.token);
  List<ServiceInOrderDetails> _services = [];
  double total = 0.0;

  List<ServiceInOrderDetails> get services => [..._services];

  double getTotalPriceOfAcceptedServices() {
    return total;
  }

  Future<void> fetchAcceptedServices(int id) async {
  final url = Uri.parse('$host/api/accepted_service_event/$id');
  print(url);
  try {
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'locale': 'en',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);

      // Parsing services
      List<ServiceInOrderDetails> services = [];
      if (responseData['services'] != null) {
        services.addAll(
          (responseData['services'] as List).map((service) {
            String imgUrl = (service['images'] as List?)?.isNotEmpty ?? false
                ? (service['images'][0]['url'] ?? '')
                : '';

            return ServiceInOrderDetails(
              // Handle nullable orderServiceId if it's present in the response
              orderServiceId: service['id'] ?? 0,
              quantity: service['quantity'] ?? 0,
              totalPrice: (service['price'] ?? 0.0).toDouble(),
              imgUrl: imgUrl,
              status: 'accepted',
              name: service['name'] ?? 'Unnamed Service',
            );
          }).toList(),
        );
      }
      if (responseData['customized_services'] != null) {
        services.addAll(
          (responseData['customized_services'] as List).map((customService) {
            String imgUrl = (customService['service_images'] as List?)?.isNotEmpty ?? false
                ? (customService['service_images'][0]['url'] ?? '')
                : '';

            return ServiceInOrderDetails(
              orderServiceId: customService['customized_service_id'],
              quantity: 1,
              totalPrice: customService['price'].toDouble(),
              imgUrl: imgUrl,
              status: 'accepted',
              name: customService['name'] ?? 'Unnamed Custom Service',
              // name: 'nameee',
              customDescription: customService['description'] ?? '',
              isCustom: true
            );
          }).toList(),
        );
      }
      double totalAcceptedServicesPrice =
          (responseData['total_accepted_services_price'] ?? 0.0).toDouble();

      total = totalAcceptedServicesPrice;
      // Do something with the services, like updating the state or notifying listeners
      _services = services;
      print(_services);

      notifyListeners(); // Notify listeners about the update
    } else {
      print('Failed to load order details');
    }
  } catch (error) {
    print(error);
    throw error;
  }
}


}
