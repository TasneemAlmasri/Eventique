//tasneem
import 'dart:convert';

import 'package:eventique/main.dart';
import 'package:eventique/models/one_cartService.dart';
import 'package:eventique/models/one_order.dart';
import 'package:eventique/models/service_in_order_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  final String token;
  final int id;
  Orders(this.token, this.id) {
    fetchPendingOrders();
    fetchProcessedOrders();
  }

  List<OneOrder> _orders = [];
  List<OneOrder> _pendingOrders = [];
  List<OneOrder> _processedOrders = [];
  OneOrder _oneOrder = OneOrder();

  List<OneOrder> get orders => [..._orders];
  List<OneOrder> get processedOrders => [..._processedOrders];
  List<OneOrder> get pendingOrders => [..._pendingOrders];
  OneOrder get oneOrder => _oneOrder;

Future<bool> addOrder(int eventId, List<OneCartService> orderedServicesFromCart) async {
  final url = Uri.parse('$host/api/insert_order');
  print(url);
  
  try {
    final List<Map<String, dynamic>> services = [];
    final List<Map<String, dynamic>> customizedServices = [];
    
    // Iterate over ordered services and sort them into the appropriate lists
    for (var service in orderedServicesFromCart) {
      if (service.isCustom == null) {
        services.add({
          'id': service.OneCartServiceId,
          'quantity': service.quantity,
        });
      } else {
        customizedServices.add({
          'price': service.totalPrice,
          'description': service.customDescription ?? '',
          'service_id': service.OneCartServiceId,
        });
      }
    }

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'user_id': id,
        'event_id': eventId,
        'services': services,
        'customized_services': customizedServices,
      }),
    );
    final responseData = json.decode(response.body);
    print(responseData);

    if (responseData['message'] =='You do not have enough money' ) {
      throw Exception('no ya helo');
    }

    if (responseData == null) {
      throw Exception('No response data');
    }
    if (responseData['Status'] == 'Failed') {
      throw Exception(responseData['Error']);
    }
    notifyListeners();
    return true; // Return true on success
  } catch (error) {
    // Handle errors
    print('Error occurred: $error');
    return false; // Return false on failure
  }
}

Future<bool> orderPackage(int eventId, int packageId) async {
  print('i am in order package $eventId and packageId $packageId');
  final url = Uri.parse('$host/api/order_package');
  print(url);
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': id.toString(),
        'package_id': packageId.toString(),
        'event_id': eventId.toString(),
      }),
    );
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Log the response body

    // Handle the response based on its content type
    if (response.headers['content-type']!.contains('application/json')) {
      // If the response is JSON
      final responseData = json.decode(response.body);
      
      print(responseData);

      if (responseData['message'] == 'You do not have enough money') {
        throw Exception('You do not have enough money');
      }

      if (responseData == null) {
        throw Exception('No response data');
      }

      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
    } else {
      // If the response is plain text
      if (response.body.contains('Order created successfully')) {
        // Handle success case based on response text
        return true; // Return true on success
      } else {
        throw Exception('Order failed with unexpected response');
      }
    }
    
    notifyListeners();
    return true; // Return true on success
  } catch (error) {
    // Handle errors
    print('Error occurred: $error');
    return false; // Return false on failure
  }
}



//taghreed
  Future<void> fetchProcessedOrders() async {
    final url = Uri.parse('$host/api/processed_orders/$id');
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
      final data = json.decode(response.body);

      // Check if 'processed_order' key exists and is not null
      if (data.containsKey('pending_order') && data['pending_order'] != null) {
        final responseData = data['pending_order'] as List<dynamic>;
        print(responseData);
        List<OneOrder> temp = [];
        for (var order in responseData) {
          temp.add(OneOrder(
            orderId: order['id'].toString(),
            orderPrice: (order['total_price'] as num).toDouble(),
            orderPaidPrice: 0.00,
            dateTime: DateTime.parse(order['order_date']),
            eventName: order['event_name'],
            orderServices: [],
          ));
        }
        print('this is temp Processed order:$temp');

        _processedOrders = temp;
        print('this is processed orders will be showed:$_processedOrders');
        // notifyListeners(); // Make sure you call this if you're using a state management solution
      } else {
        print('Processed orders key missing or null');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchPendingOrders() async {
    final url = Uri.parse('$host/api/pending_orders/$id');
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
      final data = json.decode(response.body);
      final responseData = data['pending_order'] as List<dynamic>;
      print(responseData);
      List<OneOrder> temp = [];
      for (var order in responseData) {
        temp.add(OneOrder(
          orderId: order['id'].toString(),
          orderPrice: (order['total_price'] as num).toDouble(),
          orderPaidPrice: 0.00,
          dateTime: DateTime.parse(order['order_date']),
          eventName: order['event_name'],
          orderServices: [],
        ));
      }
      print('this is temp in pending order:$temp');

      _pendingOrders = temp;
      print('this is pending orders will be showed:$_pendingOrders');
      // notifyListeners(); // Make sure you call this if you're using a state management solution
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchOrderDetails(String id) async {
    print('iam in fetchOrderDetails');
    final url = Uri.parse('$host/api/order_details');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
        },
        body: {
          'order_id': id,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);

        // Parsing services
        List<ServiceInOrderDetails> services = [];
        if (responseData['services'] != null) {
          services.addAll(
            (responseData['services'] as List).map((service) {
            String imgUrl = (service['images'] as List).isNotEmpty
                ? service['images'][0]['url']
                : '';

            return ServiceInOrderDetails(
              orderServiceId: service['id'],
              quantity: service['quantity'],
              totalPrice: service['priceinpivot'].toDouble(),
              imgUrl: imgUrl,
              status: service['status'],
              name: service['name'],
            );
          }).toList(),
          ) ;
        }
        if (responseData['customized_services'] != null) {
          services.addAll(
            (responseData['customized_services'] as List).map((customService) {
            String imgUrl = (customService['service_images'] as List).isNotEmpty
                ? customService['service_images'][0]['url']
                : '';
print('now going to ServiceInOrderDetails');
            return ServiceInOrderDetails(
              orderServiceId: customService['customized_service_id'],
              quantity: 1,
              totalPrice: customService['price'].toDouble(),
              imgUrl: imgUrl,
              status: customService['status'],
              name: customService['service_name'],
              customDescription: customService['description']??'',
              isCustom: true,
            );
          }).toList(),
          );
        }

        // Parsing order details
        OneOrder orderDetails = OneOrder(
          orderServices: services,
          orderId: responseData['order_id'],
          orderPrice: responseData['order_price'] != null
              ? responseData['order_price'].toDouble()
              : null,
          orderPaidPrice: responseData['order_paid_price'] != null
              ? responseData['order_paid_price'].toDouble()
              : null,
          dateTime: responseData['date_time'] != null
              ? DateTime.parse(responseData['date_time'])
              : null,
          eventName: responseData['event_name'],
        );

        // Do something with the orderDetails, like updating the state or notifying listeners
        _oneOrder = orderDetails;
        print(_oneOrder);

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
