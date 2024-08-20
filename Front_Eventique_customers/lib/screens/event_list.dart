import '/color.dart';
import 'package:eventique/models/one_event.dart';
import 'package:eventique/screens/create_event.dart';
import 'package:eventique/providers/events.dart';
import 'package:eventique/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  Future<void>? _fetchDataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fetchDataFuture == null) {
      _fetchDataFuture = _fetchData();
    }
  }

  Future<void> _fetchData() async {
    final eventProvider = Provider.of<Events>(context, listen: false);

    try {
      await Future.wait([
        eventProvider.fetchPlanningEvents(),
        eventProvider.fetchCompletedEvents(),
        eventProvider.fetchEventTypes(),
      ]);
    } catch (error) {
      print("Error fetching events: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<Events>(context);

    return FutureBuilder<void>(
      future: _fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error fetching data"),
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: beige,
                  surfaceTintColor: beige,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEEEA),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        dividerColor: const Color(0xffEFEEEA),
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: const Color(0xffE791A5),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFFFFFDF0),
                        ),
                        tabs: const [
                          Tab(
                            child: Text(
                              'Planning',
                              style: TextStyle(
                                  fontFamily: 'IrishGrover', fontSize: 20),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                  fontFamily: 'IrishGrover', fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      Stack(children: [
                        buildEventList(eventProvider.planningEvents, context, 1),
                        Positioned(
                          bottom: 100,
                          right: 32,
                          child: FloatingActionButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateEvent();
                                },
                              ).then((_) {
                                // Refresh the events after creating a new event
                                setState(() {
                                  _fetchDataFuture = _fetchData(); // Trigger data fetch again
                                });
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: beige,
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                            tooltip: 'Add Event',
                          ),
                        ),
                      ]),
                      buildEventList(eventProvider.completedEvents, context, 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



Widget buildEventList(
    List<OneEvent> events, BuildContext context, int controller) {
  return events.isEmpty
      ? Center(
          child: Text(
            'No Events Yet',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontFamily: 'IrishGrover',
                  fontSize: 22,
                  color: const Color.fromARGB(255, 227, 181, 193),
                ),
          ),
        )
      : ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: events.length,
          itemBuilder: (ctx, i) {
            return EventTile(
              controller: controller,
              eventDate: events[i].dateTime,
              eventName: events[i].name,
              eventTypeId: events[i].eventTypeId,
              eventBudget: events[i].budget,
              eventId: events[i].eventId,
              guests: events[i].guestsNumber,
              eventTime: events[i].time,
            );
          },
        );
}
