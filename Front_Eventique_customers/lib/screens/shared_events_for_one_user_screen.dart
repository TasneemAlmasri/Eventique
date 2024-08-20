import 'package:eventique/color.dart';
import 'package:eventique/models/one_event.dart';
import 'package:eventique/providers/events.dart';
import 'package:eventique/providers/home_provider.dart';
import 'package:eventique/providers/theme_provider.dart';
import 'package:eventique/widgets/event_tile.dart';
import 'package:eventique/widgets/shared_event_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharedEventsForOneUserScreen extends StatefulWidget {
  static const routeName = '/shared-one-user';

  @override
  State<SharedEventsForOneUserScreen> createState() =>
      _SharedEventsForOneUserScreenState();
}

class _SharedEventsForOneUserScreenState
    extends State<SharedEventsForOneUserScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  Future<void> fetchSharedEvents() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Events>(context, listen: false).fetchSharedEvents();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      fetchSharedEvents();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);
    final eventProvider = Provider.of<Events>(context);
    final sharedEvents = eventProvider.sharedEvents;

    return Scaffold(
      backgroundColor: isLight ? white : darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? white : darkBackground,
        shape: Border(
          bottom: BorderSide(
            color: isLight ? primary : white,
            width: 1.6,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'My Shared Events',
            style: TextStyle(
              color: isLight ? primary : white,
              fontSize: 24,
              fontFamily: 'IrishGrover',
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildEventList(sharedEvents, context),
    );
  }
}

Widget buildEventList(
  List<OneEvent> events,
  BuildContext context,
) {
  return events.isEmpty
      ? Center(
          child: Text(
            'No Shared Events Yet',
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
            return SharedEventTile(
              youAndUsId: events[i].youAndUsId!,
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
