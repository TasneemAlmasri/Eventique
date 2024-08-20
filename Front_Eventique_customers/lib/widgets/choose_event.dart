//in the following,there is addServiceToCart method and it uses isCustom property,so when calling this widget,you should
//pass them if you are comming from chat,(if from my bottom app bar there is no need)

import 'package:eventique/providers/auth_provider.dart';

import '/color.dart';
import 'package:eventique/models/one_event.dart';
import 'package:eventique/providers/carts.dart';
import 'package:eventique/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseEvent extends StatefulWidget {
   ChooseEvent({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.price,
    required this.serviceId,
    this.isCustom,
    this.customDescription
  });

  final int serviceId;
  final double price;
  final String imgUrl;
  final String name;
  bool? isCustom;
  String? customDescription ;

  @override
  State<ChooseEvent> createState() => _ChooseEventState();
}

class _ChooseEventState extends State<ChooseEvent> {
  int? _selectedEventId;

  @override
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context, listen: false).token;
    final cartProvider = Provider.of<Carts>(context, listen: false);
    final eventsFuture =
        Provider.of<Events>(context).eventsService.showPlanningEvent(token);

    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Choose Event to add to it',
            style: TextStyle(
              color: primary,
              fontFamily: 'IrishGrover',
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: FutureBuilder<List<OneEvent>>(
              future: eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading events'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No Events Yet',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: 'IrishGrover',
                            fontSize: 22,
                            color: const Color.fromARGB(255, 227, 181, 193),
                          ),
                    ),
                  );
                } else {
                  final events = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.celebration,),
                          ),
                          shape: CircleBorder(
                            side: BorderSide(
                              color: primary, // Stroke color
                              width: 1, // Stroke width
                            
                            ),
                          ),
                          elevation: 6,
                          color: beige,
                        ),
                        
                        title: Text(
                          event.name,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16)
                        ),
                        tileColor: _selectedEventId == event.eventId
                            ? Colors.grey[300]
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedEventId = event.eventId;
                          });
                          cartProvider.changeChosenEvent(event.eventId);

                          // Add service to cart
                          Provider.of<Carts>(context, listen: false)
                              .addServiceToCart(widget.serviceId, widget.price,
                                  widget.imgUrl, widget.name,widget.isCustom,widget.customDescription);

                          //pop the popup
                          Navigator.of(context).pop();

                          // Show snack bar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 76, 27, 75),
                              content: const Text(
                                'Added successfully',
                                style: TextStyle(
                                  color: beige,
                                ),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
