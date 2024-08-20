import 'package:eventique_company_app/models/work_hour_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SignUpForm2 extends StatefulWidget {
  SignUpForm2(
    this.submitForm2,
  );
  void Function(
    String companyName,
    String registrationNum,
    String location,
    String city,
    String country,
    List<int> days,
    Map<int, TimeOfDay?> openingTimes,
    Map<int, TimeOfDay?> closingHours,
    BuildContext ctx,
  ) submitForm2;

  @override
  State<SignUpForm2> createState() => _SignUpForm2State();
}

class _SignUpForm2State extends State<SignUpForm2> {
  final _formKey = GlobalKey<FormState>();
  String _companyName = '';
  String _registrationNumber = '';
  String _location = '';
  String? _selectedCountry;
  String? _selectedCity;
  List<int> _selectedDays = [];
  Map<int, TimeOfDay?> _openingTimes = {};
  Map<int, TimeOfDay?> _closingTimes = {};
  final List<String> countries = [
    'Syria',
    'Lebanon',
    'USA',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
  ];
  final Map<String, List<String>> cities = {
    'Syria': ['Damascus', 'Aleppo', 'Homs', 'Latakia', 'Tartus'],
    'Lebanon': ['Beirut', 'Tripoli', 'Sidon', 'Tyre', 'Zahlé'],
    'USA': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
    'Canada': ['Toronto', 'Montreal', 'Vancouver', 'Calgary', 'Ottawa'],
    'United Kingdom': [
      'London',
      'Manchester',
      'Birmingham',
      'Glasgow',
      'Leeds'
    ],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth', 'Adelaide'],
    'Germany': ['Berlin', 'Munich', 'Hamburg', 'Cologne', 'Frankfurt'],
  };
  List<MultiSelectItem<int>> _weekdays = [
    MultiSelectItem(1, 'Sunday'),
    MultiSelectItem(2, 'Monday'),
    MultiSelectItem(3, 'Tuesday'),
    MultiSelectItem(4, 'Wednesday'),
    MultiSelectItem(5, 'Thursday'),
    MultiSelectItem(6, 'Friday'),
    MultiSelectItem(7, 'Saturday'),
  ];

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitForm2(
        _companyName.trim(),
        _registrationNumber.trim(),
        _location.trim(),
        _selectedCity!.trim(),
        _selectedCountry!.trim(),
        _selectedDays,
        _openingTimes,
        _closingTimes,
        context,
      );
    }
    print(_companyName);
    print(_registrationNumber);
    print(_location);
    print(_selectedCity);
    print(_selectedCountry);
    print(_selectedDays);
    print(_openingTimes);
    print(_closingTimes);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Company Name TextFormField
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              key: ValueKey('companyName'),
              keyboardType: TextInputType.name,
              validator: (companyName) {
                if (companyName!.isEmpty || companyName.length < 4) {
                  return 'Please enter at least 4 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                label: Text('Company Name'),
                prefixIcon: Icon(Icons.location_city),
                prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (companyName) {
                _companyName = companyName!;
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          // Registration Number TextFormField
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              key: ValueKey('registrationNumber'),
              keyboardType: TextInputType.name,
              validator: (registrationNumber) {
                if (registrationNumber!.isEmpty ||
                    registrationNumber.length < 4) {
                  return 'Please enter at least 4 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                label: Text('Registration Number'),
                prefixIcon: Icon(Icons.app_registration),
                prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (registrationNumber) {
                _registrationNumber = registrationNumber!;
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          // Place Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
            alignment: Alignment.centerLeft,
            child: Text(
              'Place',
              style: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          // Location TextFormField
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              key: ValueKey('location'),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                label: Text('Location'),
                prefixIcon: Icon(Icons.place),
                prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (place) {
                if (place!.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              onSaved: (place) {
                _location = place!;
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          // Country and City Dropdowns
          SizedBox(
            width: size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.4,
                  child: FormBuilderDropdown(
                    name: 'country',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text('Country'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: countries
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedCountry = value as String?;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * 0.3,
                  child: FormBuilderDropdown(
                    name: 'city',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text('City'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _selectedCountry != null
                        ? cities[_selectedCountry]!
                            .map((city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                ))
                            .toList()
                        : [],
                    onChanged: (city) {
                      setState(() {
                        _selectedCity = city as String?;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          // Days MultiSelect
          SizedBox(
            width: size.width * 0.8,
            child: MultiSelectDialogField(
              buttonText: Text(
                'Days',
                style: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(87, 14, 87, 1),
                ),
              ),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: const Color.fromRGBO(77, 4, 81, 1),
              ),
              backgroundColor: Color.fromRGBO(255, 253, 240, 1),
              decoration: BoxDecoration(),
              title: Text(
                'Days',
                style: TextStyle(
                  fontFamily: 'IrishGrover',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(87, 14, 87, 1),
                ),
              ),
              isDismissible: true,
              selectedColor: Color.fromRGBO(204, 160, 199, 1),
              selectedItemsTextStyle: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              confirmText: Text(
                'Ok',
                style: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(87, 14, 87, 1),
                ),
              ),
              cancelText: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(87, 14, 87, 1),
                ),
              ),
              unselectedColor: Color.fromRGBO(255, 253, 240, 1),
              checkColor: Colors.white,
              searchHintStyle: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              searchIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              searchable: true,
              items: _weekdays,
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    _selectedDays.remove(value);
                    _openingTimes.remove(value);
                    _closingTimes.remove(value);
                  });
                },
              ),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _selectedDays = values.cast<int>();
                  for (var day in _selectedDays) {
                    _openingTimes[day];
                    // ??= TimeOfDay.now();
                    _closingTimes[day];
                    // ??= TimeOfDay.now();
                  }
                });
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          // Opening and Closing Times for Selected Days
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
            alignment: Alignment.centerLeft,
            child: Text(
              'Working hours',
              style: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          ..._selectedDays.map((day) {
            return Column(
              children: [
                Text(
                  _weekdays.firstWhere((element) => element.value == day).label,
                  style: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(244, 142, 196, 0.8),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * 0.38,
                        child: FormBuilderDateTimePicker(
                          name: 'opening_time_$day',
                          initialValue: _openingTimes[day] != null
                              ? DateTime(2000, 1, 1, _openingTimes[day]!.hour,
                                  _openingTimes[day]!.minute)
                              : null,
                          inputType: InputType.time,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            label: Text('From'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _openingTimes[day] = value != null
                                  ? TimeOfDay.fromDateTime(value)
                                  : null;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      SizedBox(
                        width: size.width * 0.38,
                        child: FormBuilderDateTimePicker(
                          name: 'closing_time_$day',
                          initialValue: _closingTimes[day] != null
                              ? DateTime(2000, 1, 1, _closingTimes[day]!.hour,
                                  _closingTimes[day]!.minute)
                              : null,
                          inputType: InputType.time,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            label: Text('To'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _closingTimes[day] = value != null
                                  ? TimeOfDay.fromDateTime(value)
                                  : null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            );
          }).toList(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(42, 44, 87, 0.46),
                  fixedSize: Size(size.width * 0.36, size.height * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 253, 240, 1),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _trySubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(87, 14, 87, 1),
                  fixedSize: Size(size.width * 0.36, size.height * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 253, 240, 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
