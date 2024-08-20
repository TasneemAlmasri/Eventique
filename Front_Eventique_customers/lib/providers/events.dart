import 'dart:convert';
import 'package:eventique/main.dart';
import 'package:eventique/models/one_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Events with ChangeNotifier {
  final String token;
  final int id;
  Events(
    this.token,
    this.id,
  ) {
    fetchEventTypes();
    // fetchPlanningEvents();
    // fetchCompletedEvents();
  }
  List<EventType> _eventTypes = [];
  List<OneEvent> _completedEvents = [];
  List<OneEvent> _planningEvents = [];
  List<OneEvent> _sharedEvents = [];
  bool _hasOrder = false;

  bool get hasOrder => _hasOrder;
  List<EventType> get eventTypes => _eventTypes;
  List<OneEvent> get completedEvents => [..._completedEvents];
  List<OneEvent> get planningEvents => [..._planningEvents];
  List<OneEvent> get sharedEvents => [..._sharedEvents];

  final EventTypesService _eventTypesService = EventTypesService();
  Future<void> fetchEventTypes() async {
    final fetchedEventsType = await _eventTypesService.fetchEventTypes();
    _eventTypes = fetchedEventsType;
    notifyListeners();
  }

  final EventsService eventsService = EventsService();

  void addEvent(String name, double budget, int guestsNumber, DateTime date,
      TimeOfDay time, int eventTypeId) {
    eventsService.addEvent(
        name, budget, guestsNumber, date, time, eventTypeId, token);
    // _fetchEvents();
    notifyListeners();
  }

  Future<void> fetchPlanningEvents() async {
    final fetchedEvents = await eventsService.showPlanningEvent(token);
    _planningEvents = fetchedEvents;
    notifyListeners();
  }

  Future<void> fetchCompletedEvents() async {
    final fetchedEvents = await eventsService.showCompletedEvent(token);
    _completedEvents = fetchedEvents;
    notifyListeners();
  }

  Future<void> fetchSharedEvents() async {
    final fetchedEvents = await eventsService.showSharedEvent(token, id);
    _sharedEvents = fetchedEvents;
    notifyListeners();
  }

  void deleteEvent(int eventId) {
    eventsService.deleteEvent(eventId, token).then((_) {
      fetchPlanningEvents();
      fetchCompletedEvents();
    });
    notifyListeners();
  }

  void editEvent(String? name, double? budget, int? guestsNumber,
      TimeOfDay? time, DateTime? dateTime, int? eventTypeId, int eventId) {
    eventsService.editEvent(name, budget, guestsNumber, dateTime, time,
        eventTypeId, token, eventId);
  }

  OneEvent findEventById(int eventId) {
    try {
      return _planningEvents.firstWhere((event) => event.eventId == eventId);
    } catch (e) {
      try {
        return _completedEvents.firstWhere((event) => event.eventId == eventId);
      } catch (e) {
        throw Exception('Event not found');
      }
    }
  }

  EventType getEventTypeById(int eventTypeId) {
    return _eventTypes.firstWhere((eventType) => eventType.id == eventTypeId);
  }

  //taghreed
  Future<void> doesHasOrder(int id) async {
    final url = Uri.parse('$host/api/check_orders/$id');
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
        _hasOrder = responseData['has_orders'];
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

//.........................http................................................
class EventTypesService {
  final String apiUrl = '$host/api/event-type';

  Future<List<EventType>> fetchEventTypes() async {
    print('I am in fetchEventTypessssssss and going to get them');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
      },
    );
    if (response.statusCode == 200) {
      print('I am in the fetchEventTypessssssss 200');
      final data = jsonDecode(response.body);
      final eventTypes = data['data'] as List;
      return eventTypes.map((e) {
        return EventType(id: e['id'], name: e['name']);
      }).toList();
    } else {
      throw Exception('Failed to load event types');
    }
  }
}

class EventsService {
  final String apiUrl = '$host/api/events';
  final String apiUrl1 = '$host/api/events/orderBy/planning';
  final String apiUrl2 = '$host/api/events/orderBy/completed';

  void addEvent(String name, double budget, int guestsNumber, DateTime date,
      TimeOfDay time, int eventTypeId, String token) async {
    print('I am in addEventttttttttttttttttttttttt and going to get them');
    // Format DateTime and TimeOfDay
    final String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final String formattedTime =
        '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    print('Formatted time: $formattedTime');

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'locale': 'en',
      'Authorization': 'Bearer $token',
    }, body: {
      "name": name,
      "date": formattedDate,
      "time": formattedTime,
      "budget": budget.toString().toString(),
      "guests": guestsNumber.toString(),
      "event_type_id": eventTypeId.toString(),
    });
    if (response.statusCode == 200) {
      print('I am in the addEventttttttttttttttttttttttt 200');
    } else {
      print(response.body);
      throw Exception('Failed addEventttttttttttttttttttttttt');
    }
  }

  Future<void> deleteEvent(int eventId, String token) async {
    final String apiUrl2 = '$host/api/events/$eventId/delete';
    print('I am in deleteEventtttttttttttt ');

    final response = await http.delete(
      Uri.parse(apiUrl2),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('I am in the deleteEventtttttttttttt 200');
    } else {
      print(response.body);
      throw Exception('Failed deleteEventtttttttttttt');
    }
  }

  Future<List<OneEvent>> showPlanningEvent(String token) async {
    print('I am in showEventttttttt ');

    final response = await http.get(
      Uri.parse(apiUrl1),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(token);
      print('Successfully fetched events');
      final data = jsonDecode(response.body);
      final events = data['data'] as List;

      return events.map((e) {
        final date = DateTime.parse(e['date']);
        final time = TimeOfDay(
          hour: int.parse(e['time'].substring(0, 2)),
          minute: int.parse(e['time'].substring(3, 5)),
        );

        return OneEvent(
          eventId: e['id'],
          name: e['name'],
          budget: e['budget'].toDouble(), // Assuming budget is double
          guestsNumber: e['guests'],
          time: time,
          dateTime: date,
          eventTypeId: e['event_type_id'],
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed showEventttttttt');
    }
  }

  Future<List<OneEvent>> showCompletedEvent(String token) async {
    print('I am in showEventttttttt ');

    final response = await http.get(
      Uri.parse(apiUrl2),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Successfully fetched events');
      final data = jsonDecode(response.body);
      final events = data['data'] as List;

      return events.map((e) {
        final date = DateTime.parse(e['date']);
        final time = TimeOfDay(
          hour: int.parse(e['time'].substring(0, 2)),
          minute: int.parse(e['time'].substring(3, 5)),
        );

        return OneEvent(
          eventId: e['id'],
          name: e['name'],
          budget: e['budget'].toDouble(), // Assuming budget is double
          guestsNumber: e['guests'],
          time: time,
          dateTime: date,
          eventTypeId: e['event_type_id'],
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed showEventttttttt');
    }
  }

  Future<List<OneEvent>> showSharedEvent(String token, int id) async {
    print('I am in show Shared Eventttttttt ');
    final url = Uri.parse('$host/api/getYouAndUsByUser/$id');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Successfully fetched shared events');
      print(response.body);
      final data = jsonDecode(response.body);
      final events = data['youandus'] as List;
      return events.map((e) {
        final event = e['event'];
        final youandusId = e['id'];
        final date = DateTime.parse(event['date']);
        final time = TimeOfDay(
          hour: int.parse(event['time'].substring(0, 2)),
          minute: int.parse(event['time'].substring(3, 5)),
        );

        return OneEvent(
          youAndUsId: youandusId,
          eventId: event['id'],
          name: event['name'],
          budget: event['budget'].toDouble(),
          guestsNumber: event['guests'],
          time: time,
          dateTime: date,
          eventTypeId: event['event_type_id'],
        );
      }).toList();
    } else {
      print(response.body);
      throw Exception('Failed showEventttttttt');
    }
  }

  void editEvent(
      String? name,
      double? budget,
      int? guestsNumber,
      DateTime? date,
      TimeOfDay? time,
      int? eventTypeId,
      String token,
      int eventId) async {
    print('I am in editEvent and going to edit the event');
    final String apiUrl = '$host/api/events/$eventId';

    // Format DateTime and TimeOfDay
    String? formattedDate;
    if (date != null) {
      formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    String? formattedTime;
    if (time != null) {
      formattedTime = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }

    // Create the body map and add non-null fields
    final Map<String, String> body = {};
    if (name != null) body['name'] = name;
    if (formattedDate != null) body['date'] = formattedDate;
    if (formattedTime != null) body['time'] = formattedTime;
    if (budget != null) body['budget'] = budget.toString();
    if (guestsNumber != null) body['guests'] = guestsNumber.toString();
    if (eventTypeId != null) body['event_type_id'] = eventTypeId.toString();

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'locale': 'en',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Event edited successfully');
    } else {
      print(response.body);
      throw Exception('Failed to edit event');
    }
  }
}

//.....................http model...
class EventType {
  final int id;
  final String name;

  EventType({required this.id, required this.name});
}
