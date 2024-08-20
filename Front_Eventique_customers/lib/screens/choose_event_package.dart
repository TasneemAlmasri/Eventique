import 'package:eventique/providers/auth_provider.dart';
import '/color.dart';
import 'package:eventique/models/one_event.dart';
import 'package:eventique/providers/events.dart';
import 'package:eventique/providers/orders.dart'; // Import Orders provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseEventPackage extends StatefulWidget {
  final int packageId;

  ChooseEventPackage({super.key, required this.packageId});

  @override
  State<ChooseEventPackage> createState() => _ChooseEventPackageState();
}

class _ChooseEventPackageState extends State<ChooseEventPackage> {
  int? _selectedEventId;
  bool _isLoading = false; // Add loading state

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context, listen: false).token;
    final eventsFuture =
        Provider.of<Events>(context).eventsService.showPlanningEvent(token);

    return 
    
    AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor, // Set the dialog's background color
      contentPadding: const EdgeInsets.all(16.0),
      title: const Text(
        'Choose Event to add to it',
        style: TextStyle(
          color: primary,
          fontFamily: 'IrishGrover',
          fontSize: 20,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite, // Ensure content width is correct
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
              return Column(
                mainAxisSize: MainAxisSize.min, // Ensures that the column takes only the needed space
                children: [
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true, // Allows the ListView to take only the necessary height
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.celebration,
                              ),
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
                          title: Text(event.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 16)),
                          tileColor: _selectedEventId == event.eventId
                              ? Colors.grey[300]
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedEventId = event.eventId;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _selectedEventId == null || _isLoading
              ? null
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    bool success = await Provider.of<Orders>(context,
                            listen: false)
                        .orderPackage(_selectedEventId!, widget.packageId); // Pass selected event ID and package ID

                    if (success) {
                      Navigator.of(context).pop(); // Close the popup on success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 76, 27, 75),
                          content: Text(
                            'Ordered successfully',
                            style: TextStyle(
                              color: beige,
                            ),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red,
                          content: Text(
                            'You do not have enough money',
                            style: TextStyle(
                              color: beige,
                            ),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red,
                        content: Text(
                          'Order failed. Please try again.',
                          style: TextStyle(
                            color: beige,
                          ),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
          ),
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Color(0xFFFFFDF0),
                )
              : const Text(
                  'Order',
                  style: TextStyle(
                      fontFamily: 'IrishGrover',
                      fontSize: 18,
                      color: Color(0xFFFFFDF0)),
                ),
        ),
      ],
    );
  }
}
