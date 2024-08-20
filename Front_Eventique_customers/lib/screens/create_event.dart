import 'package:confetti/confetti.dart';
import '/color.dart';
import 'package:eventique/models/one_event.dart';
import 'package:eventique/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  EventType? _selectedEventType;
  late final ConfettiController _confettiController;
  bool isPlaying = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController
          .play(); // Start the confetti animation when the dialog opens
    });

    _timeFocusNode.addListener(() {
      if (_timeFocusNode.hasFocus) {
        _selectTime(context);
        _timeFocusNode.unfocus();
      }
    });

    _dateFocusNode.addListener(() {
      if (_dateFocusNode.hasFocus) {
        _selectDate(context);
        _dateFocusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _guestsController.dispose();
    _budgetController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _timeFocusNode.dispose();
    _dateFocusNode.dispose();
    _confettiController.dispose();
    super.dispose();
  }

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
            dialogTheme: const DialogTheme(
              backgroundColor: beige,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final eventProvider = Provider.of<Events>(context);
    final List<EventType> eventTypes = eventProvider.eventTypes;

    return AlertDialog(
      backgroundColor: beige,
      surfaceTintColor: beige,
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: _formKey,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: 0,
                    colors: const [
                      Color.fromARGB(255, 243, 159, 181),
                      Color.fromARGB(255, 243, 227, 90),
                      Color.fromARGB(255, 200, 67, 103),
                      Color.fromARGB(255, 3, 169, 161),
                    ],
                    shouldLoop: false,
                    emissionFrequency: 0.03,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          _confettiController.stop();
                        } else {
                          _confettiController.play();
                        }
                        isPlaying = !isPlaying;
                      },
                      icon: const Icon(
                        Icons.celebration,
                        size: 100.0,
                        color: Color(0xffDD8CA1),
                      ),
                    ),
                    Text(
                      "Create a new event",
                      style: TextStyle(
                        fontFamily: 'IrishGrover',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      "Set up an event and start planning it",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      style: textStyle,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Name",
                        suffixIcon: const Icon(Icons.edit),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateController,
                            focusNode: _dateFocusNode,
                            style: textStyle,
                            decoration: textFieldDecoration.copyWith(
                              hintText: "Date",
                              suffixIcon:
                                  const Icon(Icons.calendar_today, size: 18),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Select a date';
                              }
                              return null;
                            },
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _timeController,
                            focusNode: _timeFocusNode,
                            style: textStyle,
                            decoration: textFieldDecoration.copyWith(
                              hintText: "Time",
                              suffixIcon:
                                  const Icon(Icons.access_time, size: 18),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Select a time';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _guestsController,
                            style: textStyle,
                            decoration: textFieldDecoration.copyWith(
                              hintText: "Guests",
                              suffixIcon: const Icon(Icons.people),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Enter number';
                              }
                              final guests = int.tryParse(value);
                              if (guests == null || guests <= 0) {
                                return 'Incorrect value';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _budgetController,
                            style: textStyle,
                            decoration: textFieldDecoration.copyWith(
                              hintText: "Budget",
                              suffixIcon: const Icon(Icons.attach_money),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Enter budget';
                              }
                              final budget = int.tryParse(value);
                              if (budget == null || budget <= 0) {
                                return 'Incorrect value';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<EventType>(
                      iconEnabledColor: const Color(0xffCCA0C7),
                      value: _selectedEventType,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Event Type",
                        suffixIcon: null,
                      ),
                      validator: (value) {
                        if (_selectedEventType == null) {
                          return 'Select event type';
                        }
                        return null;
                      },
                      items: eventTypes.map((eventType) {
                        return DropdownMenuItem(
                          value: eventType,
                          child: Text(eventType.name, style: textStyle),
                        );
                      }).toList(),
                      onChanged: (EventType? newValue) {
                        setState(() {
                          _selectedEventType = newValue;
                        });
                      },
                      dropdownColor: beige,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              try {
                // Split the time string into parts
                List<String> timeParts = _timeController.text.split(":");
                int hour = int.parse(timeParts[0]);
                int minute = int.parse(timeParts[1].split(" ")[0]);
                String period = timeParts[1].split(" ")[1];

                // Adjust the hour based on the period (AM/PM)
                if (period == "PM" && hour < 12) {
                  hour += 12;
                } else if (period == "AM" && hour == 12) {
                  hour = 0;
                }

                // Create the event
                eventProvider.addEvent(
                  _nameController.text,
                  double.parse(_budgetController.text),
                  int.parse(_guestsController.text),
                  DateFormat('yyyy-MM-dd').parse(_dateController.text),
                  TimeOfDay(hour: hour, minute: minute),
                  _selectedEventType!.id,
                );

                Navigator.of(context).pop();

                // Schedule the Snackbar to show after the dialog is dismissed
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color.fromARGB(255, 76, 27, 75),
                      content: const Text(
                        'Created successfully',
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: primaryColor,
          ),
          child: const SizedBox(
            width: double.infinity,
            child: Center(
              child: Text(
                "Create",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: beige,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

final borderSideWithFocusColor = const BorderSide(color: primary);
final borderSideWithoutFocusColor = BorderSide(color: primary.withOpacity(0.7));
final textStyle =
    const TextStyle(fontSize: 16, color: primary, fontWeight: FontWeight.bold);
final hintTextStyle = TextStyle(fontSize: 16, color: primary.withOpacity(0.4));

final textFieldDecoration = InputDecoration(
  hintStyle: hintTextStyle,
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    borderSide: borderSideWithoutFocusColor,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    borderSide: borderSideWithFocusColor,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    borderSide: borderSideWithoutFocusColor,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: primary.withOpacity(0.7)), // Adjusted color
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: primary.withOpacity(0.7)), // Adjusted color
  ),
  suffixIconColor: const Color(0xffCCA0C7),
  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
);
