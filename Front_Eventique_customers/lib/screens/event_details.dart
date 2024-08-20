import '/color.dart';
import 'package:eventique/screens/create_event.dart';
import 'package:eventique/providers/accepted_services.dart';
import 'package:eventique/providers/events.dart';
import 'package:eventique/widgets/accepted_serv_eve_det.dart';
import 'package:eventique/widgets/my_pie_chart.dart';
import 'package:eventique/widgets/my_row_texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatefulWidget {
  EventDetails({
    super.key,
    required this.eventId,
  });

  final int eventId;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
//controller
  final TextEditingController _changeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isInit = true;
  Future<void> fetchAccepted(int eventId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AcceptedServicesPro>(context, listen: false)
          .fetchAcceptedServices(eventId);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchHasOrder(int eventId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Events>(context).doesHasOrder(widget.eventId);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

//dispose controller
  @override
  void dispose() {
    _changeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      fetchHasOrder(widget.eventId);
      fetchAccepted(widget.eventId);

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<Events>(context, listen: true);
    final acceptedProvider =
        Provider.of<AcceptedServicesPro>(context, listen: true);
    final event = eventProvider.findEventById(widget.eventId);
    final services = acceptedProvider.services;
    final bool hasOrder = eventProvider.hasOrder; //if it has value the pen will disappear,should be null to show the pen
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    print(hasOrder);
    // ...................................................................show dialog.............................................................................
    //show dialog method
    Future showEditDialog(String changeText) {
      _changeController.clear();
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: beige,
          surfaceTintColor: beige,
          title: Center(
            child: Text(
              'Change $changeText',
              style: TextStyle(
                fontFamily: 'IrishGrover',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _changeController,
              style: TextStyle(
                  fontSize: 16, color: primary, fontWeight: FontWeight.bold),
              decoration: textFieldDecoration.copyWith(
                hintText: changeText,
                suffixIcon: const Icon(Icons.edit),
              ),
              validator: (value) {
                //budget validat
                if (changeText == 'Budget') {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Enter a $changeText';
                  }
                  if (double.tryParse(value) == null ||
                      double.tryParse(value)! <= 0) {
                    return 'Incorrect value';
                  }
                  return null;
                }

                //gustes validate
                else if (changeText == 'Guests') {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Enter a $changeText';
                  }
                  if (int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Incorrect value';
                  }
                  return null;
                }

                //name vaidate
                else {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Enter a $changeText';
                  }
                  return null;
                }
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  try {
                    // edit the event
                    if (changeText == 'Budget') {
                      eventProvider.editEvent(
                          null,
                          double.tryParse(_changeController.text),
                          null,
                          null,
                          null,
                          null,
                          widget.eventId);
                    } else if (changeText == 'Guests') {
                      eventProvider.editEvent(
                          null,
                          null,
                          int.parse(_changeController.text),
                          null,
                          null,
                          null,
                          widget.eventId);
                    } else if (changeText == 'Name') {
                      eventProvider.editEvent(_changeController.text, null,
                          null, null, null, null, widget.eventId);
                    }
                    setState(() {});

                    // Close the dialog
                    Navigator.of(context).pop();

                    // Schedule the Snackbar to show after the dialog is dismissed
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 76, 27, 75),
                          content: Text(
                            'Edited successfully',
                            style: TextStyle(
                              color: beige,
                            ),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    });
                  } catch (e) {
                    print('Error: $e');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                backgroundColor: primary.withOpacity(0.8),
              ),
              child: Center(
                child: Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IrishGrover',
                    color: beige,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

// ...............................................................date and time.......................................................................
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              dialogBackgroundColor: beige,
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: beige,
                surface: beige,
              ),
              dialogTheme: DialogTheme(
                backgroundColor: beige,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          eventProvider.editEvent(
              null, null, null, null, picked, null, widget.eventId);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color.fromARGB(255, 76, 27, 75),
              content: Text(
                'Edited successfully',
                style: TextStyle(
                  color: beige,
                ),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        });
      }
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: beige,
                dialHandColor: primary,
                hourMinuteTextColor: primary,
                hourMinuteColor: secondary.withOpacity(0.1),
                dialBackgroundColor: beige.withOpacity(0.5),
                dayPeriodColor: primary.withOpacity(0.8),
                entryModeIconColor: primary,
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(primary),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          eventProvider.editEvent(
              null, null, null, picked, null, null, widget.eventId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(255, 76, 27, 75),
                content: Text(
                  'Edited successfully',
                  style: TextStyle(
                    color: beige,
                  ),
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: 'IrishGrover'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextRow(
              firstString: 'Name',
              secondString: event.name,
              onPressed: () => showEditDialog('Name'),
              hasOrder: hasOrder,
            ),
            MyTextRow(
              firstString: 'Time',
              secondString: event.time.format(context),
              onPressed: () => _selectTime(context),
              hasOrder: hasOrder,
            ),
            MyTextRow(
              firstString: 'Date',
              secondString: '${event.dateTime.toLocal()}'.split(' ')[0],
              onPressed: () => _selectDate(context),
              hasOrder: hasOrder,
            ),
            MyTextRow(
              firstString: 'Guests',
              secondString: '${event.guestsNumber} Person',
              onPressed: () => showEditDialog('Guests'),
              hasOrder: hasOrder,
            ),
            MyTextRow(
              firstString: 'Budget',
              secondString: '${event.budget} \$',
              onPressed: () => showEditDialog('Budget'),
              hasOrder: hasOrder,
            ),
            services.isEmpty
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: MyPieChart(
                      totalPriceForOrder:
                          acceptedProvider.getTotalPriceOfAcceptedServices(),
                      services: services,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Row(
                children: [
                  Text(
                    'Accepted Services',
                    style: bodyMediumStyle!.copyWith(
                        fontFamily: 'IrishGrover',
                        fontSize: 22,
                        fontWeight: FontWeight.normal),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      acceptedProvider.services.length.toString(),
                      style: TextStyle(color: primary),
                    ),
                  )
                ],
              ),
            ),
            _isLoading
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator()),
                )
                : AcceptedServices(
                    acceptedList: services,
                  ),
          ],
        ),
      ),
    );
  }
}
