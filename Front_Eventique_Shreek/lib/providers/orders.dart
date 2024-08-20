import 'dart:convert';
import '/main.dart';
import '/models/service_in_order_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  final String token;
  final int companyId;
  Orders(this.token,this.companyId) {
    fetchPendingOrders();
    fetchProcessedOrders();
  }

  final OrdersService _ordersService = OrdersService();

  List<ServiceInOrderDetails> _orders = [];
  List<ServiceInOrderDetails> _pendingOrders = [];
  List<ServiceInOrderDetails> _processdOrders = [];

  List<ServiceInOrderDetails> get orders => [..._orders];
  List<ServiceInOrderDetails> get pendingOrders => [..._pendingOrders];
  List<ServiceInOrderDetails> get proccecdOrders => [..._processdOrders];

  Future<void> fetchPendingOrders() async {
    final fetchedOrders = await _ordersService.fetchPendingOrders(token,companyId);
    _pendingOrders = fetchedOrders;
    notifyListeners();
  }

  Future<void> fetchProcessedOrders() async {
    final fetchedOrders = await _ordersService.fetchProcessedOrders(token,companyId);
    _processdOrders = fetchedOrders;
    notifyListeners();
  }

  Future<void> acceptService(int orderID,int serviceID,int? isCustomized) async {
    _ordersService.acceptService(token,orderID,serviceID,isCustomized);
     await fetchPendingOrders();
    await fetchProcessedOrders();
    notifyListeners();
  }

  Future<void> rejectService(int orderID,int serviceID,int? isCustomized) async {
    _ordersService.rejectService(token,orderID,serviceID,isCustomized);
     await fetchPendingOrders();
    await fetchProcessedOrders();
    notifyListeners();
  }
}

//..............http.......................
class OrdersService {

Future<List<ServiceInOrderDetails>> fetchPendingOrders(String token, int companyId) async {
  final String apiUrl = '$host/api/company/$companyId/pending-services';
  print('I am in fetchPendingOrders');

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('I am in fetchPendingOrder 200');
    print(response.body);
    final data = jsonDecode(response.body);
    final services = data['services'] as List;
    final customizedServices = data['customized_services'] as List;

    List<ServiceInOrderDetails> result = [];

    // Process regular services
    result.addAll(services.map((e) {
      final orderDate = e['order_date'];
      final eventDate = e['event_date'];

      final date = DateTime.parse(orderDate);
      final dueDate = DateTime.parse(eventDate);
      final imgUrl = e['service_images'].isNotEmpty ? e['service_images'][0]['url'] : '';

      return ServiceInOrderDetails(
        name: e['service_name'].toString(),
        imgUrl: imgUrl,
        orederdBy: e['user_name'],
        orderId: e['order_id'],
        serviceId: e['service_id'],
        quantity: e['quantity'],
        totalPrice: double.parse(e['price'].toString()), // Ensure correct parsing
        dueDate: dueDate,
        arrivDate: date,
        status: 'pending',
      );
    }).toList());

    // Process customized services
    result.addAll(customizedServices.map((e) {
      final orderDate = e['order_date'];
      final eventDate = e['event_date'];

      final date = DateTime.parse(orderDate);
      final dueDate = DateTime.parse(eventDate);
      final imgUrl = e['service_images'].isNotEmpty ? e['service_images'][0]['url'] : '';

      return ServiceInOrderDetails(
        name: e['service_name'].toString(),
        imgUrl: imgUrl,
        orederdBy: e['user_name'],
        orderId: e['order_id'],
        serviceId: e['customized_service_id'],
        quantity: 1, 
        totalPrice: double.parse(e['price'].toString()), // Ensure correct parsing
        dueDate: dueDate,
        arrivDate: date,
        status: 'pending',
        isCustomized: 1,
        customDescription: e['description'],
      );
    }).toList());
     print('heeeeeeeeeeeeeere you neeeeeeeeeeeeed this:::::::::::::::::::::::${response.body}');
    return result;
  } else {
    print(response.body);
    throw Exception('Failed to fetch orders');
  }
}



  Future<List<ServiceInOrderDetails>> fetchProcessedOrders(String token, int companyId) async {
  final String apiUrl = '$host/api/company/$companyId/processed-services';
  print('I am in fetchProcessedOrders');

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('i am in fetched fetchProcessedOrders 200');
    final data = jsonDecode(response.body);
    final services = data['services'] as List;
    final customizedServices = data['customized_services'] as List;
    print('serv is $services');
    print('custom is $customizedServices');

    List<ServiceInOrderDetails> result = [];

    // Process regular services
    result.addAll(services.map((e) {
      final orderDate = e['order_date'];
      final eventDate = e['event_date'];

      final date = DateTime.parse(orderDate);
      final dueDate = DateTime.parse(eventDate);
      final imgUrl = e['service_images'].isNotEmpty ? e['service_images'][0]['url'] : '';
      print('After image URL processing');

      return ServiceInOrderDetails(
        name: e['service_name'].toString(),
        imgUrl: imgUrl,
        orederdBy: e['user_name'],
        quantity: e['quantity'],
        totalPrice: double.parse(e['price'].toString()), // Ensure correct parsing
        dueDate: dueDate,
        arrivDate: date,
        status: 'Processed',
        
      );
    }).toList());
print('now going to custoooooooooooooooooooooooom $customizedServices');
    // Process customized services
    result.addAll(customizedServices.map((e) {
      final orderDate = e['order_date'];
      final eventDate = e['event_date'];

      final date = DateTime.parse(orderDate);
      final dueDate = DateTime.parse(eventDate);
      final imgUrl = e['service_images'].isNotEmpty ? e['service_images'][0]['url'] : '';

      return ServiceInOrderDetails(
        name: e['service_name'].toString(),
        imgUrl: imgUrl,
        orederdBy: e['user_name'].toString(),
        quantity: 1, 
        totalPrice: double.parse(e['price'].toString()), // Ensure correct parsing
        dueDate: dueDate,
        arrivDate: date,
        status: 'Processed',
        isCustomized: 1,
        customDescription: e['description'].toString(),
      );
    }).toList());
print('fetched processed goooooooooooooood');
    return result;
  }  else {
    print(response.body);
    throw Exception('Failed to fetch orders');
  }
}

  void acceptService(String token, int orderID, int serviceID, int? isCustomized) async {
    print('token $token orderID $orderID serviceID $serviceID isCustomized $isCustomized');
  final String apiUrl = '$host/api/update_service_status';
  print('I am in acceptService');
  print('orderId $orderID and serviceId $serviceID');

  // Create the base body map
  Map<String, String> body = {
    'order_id': orderID.toString(),
    'status': 'ACCEPTED',
  };

  // Conditionally add 'service_id' or 'customized_service_id'
  if (isCustomized == null) {
    body['service_id'] = serviceID.toString();
  } else {
    body['customized_service_id'] = serviceID.toString();
  }

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    print('Successfully accepted service');
  } else {
    print(response.body);
    throw Exception('Failed to accept service');
  }
}


  void rejectService(String token,int orderID,int serviceID,int? isCustomized) async {
    final String apiUrl = '$host/api/update_service_status';
    print('I am in rejectService ');

    // Create the base body map
  Map<String, String> body = {
    'order_id': orderID.toString(),
    'status': 'ACCEPTED',
  };

  // Conditionally add 'service_id' or 'customized_service_id'
  if (isCustomized == null) {
    body['service_id'] = serviceID.toString();
  } else {
    body['customized_service_id'] = serviceID.toString();
  }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
      body: body
    );
    if (response.statusCode == 200) {
      print('Successfully rejectService');
     }else {
      print(response.body);
      throw Exception('Failed');
    }
  }

}
