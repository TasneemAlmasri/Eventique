import 'package:eventique_company_app/models/eventType_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/main.dart';
import 'dart:convert';

class EventProvider with ChangeNotifier {
  List<EventType> _eventsTypes = [];

  List<EventType> get allTypes {
    return [..._eventsTypes];
  }

  Future<void> getTypes() async {
    final url = Uri.parse('$host/api/event-type');
    print(url);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'locale': 'en',
    });
    final responseData = json.decode(response.body);
    print(responseData);

    // Directly access the 'data' key and iterate over the list
    final types = responseData['data'] as List<dynamic>;
    final List<EventType> temp = [];
    types.forEach((type) {
      temp.add(EventType(
        id: type['id'],
        type: type['name'],
      ));
    });
    // print(temp);
    _eventsTypes = temp;
    print('eventTypes list in provider:$_eventsTypes');
    notifyListeners();
  }
}
