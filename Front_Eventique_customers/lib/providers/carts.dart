import 'package:eventique/models/one_cartService.dart';
import 'package:flutter/material.dart';

class Carts with ChangeNotifier {
  //map each event id with its cart,
  final Map<int, List<OneCartService>> _carts = {};

// gets all the carts for all events"not needed !"
   Map<int, List<OneCartService>> get carts => _carts;

// gets an event cart(one cart only),if not found it returns empty map
  List< OneCartService> getCart(int eventId) {
    return _carts[eventId] ?? [];
  }

  //i have quantity for each service thats why i am using a map
  //make sure this map only contains normal services(no custom)
  final Map<int, int> _quantities = {};

  //get specific service quantity
  int getQuantity(int serviceId) {
    return _quantities[serviceId] ?? 1;
  }

  void incrementQuantity(int serviceId) {
    _quantities[serviceId] = (_quantities[serviceId] ?? 1) + 1;
    notifyListeners();
  }

  void decrementQuantity(int serviceId) {
    if (_quantities[serviceId] != null && _quantities[serviceId]! > 1) {
      _quantities[serviceId] = _quantities[serviceId]! - 1;
    }
    notifyListeners();
  }

  int chosenEventId = -1;
  void changeChosenEvent(int eventId) {
    chosenEventId = eventId;
    notifyListeners();
  }

  void addServiceToCart(int serviceId, double servicePrice, String imgUrl, String name,bool? isCustom,String? customDescription ) {
    if (chosenEventId==-1) {
      throw Exception('No event chosen');
    }

    if (!_carts.containsKey(chosenEventId)) {
      _carts[chosenEventId] = [];
    }

    final eventCart = _carts[chosenEventId]!;
//below,when adding to cart,i have to check if the service already exists,so i only update the quantity
//to check,i will check using the service id,but this is not enough,since services from firebase can have the same id with normal services
//so i will check using ids and isCustom value to make sure i am in the same service
    final existingServiceIndex = eventCart.indexWhere((service) => (service.OneCartServiceId == serviceId)&&(service.isCustom==isCustom));

//only normal services should  enter this 'if',because its meant to add an already existing service(which only happens in the case of normal ones)
    if (existingServiceIndex != -1) {
      final existingService = eventCart[existingServiceIndex];
      final newQuantity = existingService.quantity + getQuantity(serviceId);
      final newTotalPrice = newQuantity * servicePrice;
      eventCart[existingServiceIndex] =
       OneCartService(
        OneCartServiceId: serviceId,
        quantity: newQuantity,
        totalPrice: newTotalPrice,
        imgUrl: imgUrl,
        name: name,
      );
    } else {
      //normal and entering the cart for the first time 
      if(isCustom==null){
        eventCart.add(
        OneCartService(
        OneCartServiceId: serviceId,
        quantity: getQuantity(serviceId),
        totalPrice: getQuantity(serviceId) * servicePrice,
        imgUrl: imgUrl,
        name: name,
      ),
      );
      }
      //custom 
      else{
        eventCart.add(
          OneCartService(
        OneCartServiceId: serviceId,
        quantity: 1,
        totalPrice: servicePrice,
        imgUrl: imgUrl,
        name: name,
        isCustom:true,
        customDescription: customDescription,
      )
        );
        
      }
      
    }
    _quantities[serviceId] = 1;
    chosenEventId = -1;

    notifyListeners();
  }

  removeServiceFromCart(int eventId, int serviceId,bool?isCustom ) {
    if (_carts.containsKey(eventId)) {
      final eventCart = _carts[eventId]!;
      eventCart.removeWhere((element) => (element.OneCartServiceId==serviceId)&&(element.isCustom==isCustom));
      if (eventCart.isEmpty) {
        _carts.remove(eventId);
      }
      notifyListeners();
    }
  }

  //when ordering ,the cart should become empty
  void clearCart(int eventId) {
    if (_carts.containsKey(eventId)) {
      _carts[eventId]!.clear();
      _carts.remove(eventId);
      notifyListeners();
    }
  }

  double getOrderTotalPrice(int eventId) {
    double total = 0.0;
    if (_carts.containsKey(eventId)) {
      _carts[eventId]!.forEach(( cartService) {
        total += cartService.totalPrice;
      });
    }
    return total;
  }
}
