import 'package:eventique_company_app/models/eventType_model.dart';
import 'package:eventique_company_app/models/serviceCategory_model.dart';
import 'package:eventique_company_app/providers/event_provider.dart';
import 'package:eventique_company_app/providers/services_provider.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';

class SignUpForm3 extends StatefulWidget {
  SignUpForm3(
    this.submitForm3,
  );
  final void Function(
    List<int> selectedCat,
    List<int> selctedTypes,
    String description,
    BuildContext ctx,
  ) submitForm3;

  @override
  State<SignUpForm3> createState() => _SignUpForm3State();
}

class _SignUpForm3State extends State<SignUpForm3> {
  final _formKey = GlobalKey<FormState>();
  bool _loadingCat = false;
  bool _loadingEvents = false;
  List<int> _selectedServicesCategory = [];
  List<int> _selectedEventsType = [];
  String _description = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllCategories();
    fetchAllEventsTypes();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitForm3(
        _selectedServicesCategory,
        _selectedEventsType,
        _description,
        context,
      );
    }
    print('selected categories in form:$_selectedServicesCategory');
    print('selected events in form:$_selectedEventsType');
    //use those values to send out auth request...
  }

  Future<void> fetchAllCategories() async {
    try {
      setState(() {
        _loadingCat = true;
      });
      await Provider.of<ServiceProvider>(context, listen: false)
          .getCategories();
      setState(() {
        _loadingCat = false;
      });
    } catch (error) {
      setState(() {
        _loadingCat = false;
      });
      print(error);
    }
  }

  Future<void> fetchAllEventsTypes() async {
    try {
      setState(() {
        _loadingEvents = true;
      });
      await Provider.of<EventProvider>(context, listen: false).getTypes();
      setState(() {
        _loadingEvents = false;
      });
    } catch (error) {
      setState(() {
        _loadingEvents = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final _servicesCategory =
        Provider.of<ServiceProvider>(context).allCategories;
    final _eventsType = Provider.of<EventProvider>(context).allTypes;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            width: size.width * 0.8,
            child: MultiSelectDialogField(
              buttonText: Text(
                'Services',
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
                'Services',
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
              unselectedColor: Color.fromRGBO(212, 211, 209, 1),
              itemsTextStyle: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              searchIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              searchable: true,
              items: _servicesCategory
                  .map((e) => MultiSelectItem<int>(e.id as int, e.category))
                  .toList(),
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    _selectedServicesCategory.remove(value);
                  });
                },
              ),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _selectedServicesCategory =
                      values.map((e) => e as int).toList();
                });
              },
            ),
          ),
          SizedBox(
            height: size.width * 0.02,
          ),
          SizedBox(
            width: size.width * 0.8,
            child: MultiSelectDialogField(
              buttonText: Text(
                'Events',
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
                'Events',
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
              unselectedColor: Color.fromRGBO(212, 211, 209, 1),
              itemsTextStyle: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              searchIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
              searchable: true,
              items: _eventsType
                  .map((e) => MultiSelectItem<int>(e.id as int, e.type))
                  .toList(),
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    _selectedEventsType.remove(value);
                  });
                },
              ),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _selectedEventsType = values.map((e) => e as int).toList();
                });
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: TextStyle(
                fontFamily: 'CENSCBK',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 14, 87, 1),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: size.width * 0.8,
              child: TextFormField(
                key: ValueKey('description'),
                keyboardType: TextInputType.text,
                maxLines: 6,
                validator: (description) {
                  if (description!.isEmpty) {
                    return 'This field is required';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Describe your company ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSaved: (description) {
                  _description = description!;
                },
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
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
