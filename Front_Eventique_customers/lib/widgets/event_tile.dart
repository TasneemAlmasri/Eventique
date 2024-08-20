import 'package:eventique/screens/share_event_screen.dart';

import '/color.dart';
import 'package:eventique/screens/cart.dart';
import 'package:eventique/screens/event_details.dart';
import 'package:eventique/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.controller,
    required this.eventTypeId,
    required this.eventBudget,
    required this.eventId,
    required this.guests,
    required this.eventTime,
  });

  final String eventName;
  final double eventBudget;
  final int eventId;
  final DateTime eventDate;
  final int? controller;
  final int eventTypeId;
  final int guests;
  final TimeOfDay eventTime;

  @override
  Widget build(BuildContext context) {
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xff662465), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
      color: const Color(0xFFFFFDF0),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => EventDetails(
                eventId: eventId,
              ),
            ),
          );
        },
        onLongPress: () async {
          controller == 1
              ? await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFFFFFDF0),
                    title: Text(
                      'Delete this event?',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'By deleting this event, we will not cancel any accepted orders, and the money spent will not be refunded.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Continue',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Provider.of<Events>(context, listen: false)
                              .deleteEvent(eventId);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )
              : print('do nothing');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                shape: CircleBorder(
                  side: BorderSide(
                    color: primary,
                    width: 1,
                  ),
                ),
                elevation: 6,
                color: beige,
                margin: const EdgeInsets.only(left: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Icon(Icons.celebration),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventName,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyMediumStyle!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'IrishGrover',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${eventDate.toLocal()}'.split(' ')[0],
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyMediumStyle.copyWith(
                          color: const Color.fromARGB(255, 174, 165, 168),
                          fontFamily: 'IrishGrover',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    controller == 1
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => TestCart(
                                eventBudget: eventBudget,
                                eventId: eventId,
                                eventName: eventName,
                              ),
                            ),
                          )
                        : Navigator.of(context).pushNamed(
                            ShareEventScreen.routeName,
                            arguments: eventId,
                          );
                    print('in event tile the id :$eventId');
                  },
                  icon: Icon(
                    controller == 1 ? Icons.trolley : Icons.share,
                    color: secondary,
                    size: controller == 1 ? 32 : 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
