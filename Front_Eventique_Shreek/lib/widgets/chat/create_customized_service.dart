import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventique_company_app/color.dart';
import 'package:eventique_company_app/models/one_service.dart';
import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:eventique_company_app/providers/services_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCustomizedService extends StatefulWidget {
  final int userId;
  CreateCustomizedService(this.userId);

  @override
  State<CreateCustomizedService> createState() =>
      _CreateCustomizedServiceState();
}

class _CreateCustomizedServiceState extends State<CreateCustomizedService> {
  final _formKey = GlobalKey<FormState>();
  OneService _selectedService = OneService();
  String _newDescription = '';
  double _newPrice = 0.0;

  void _saveCustomizedService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<AuthVendor>(context, listen: false);
      final vendorData = provider.userData;
      final vendorId = provider.userId;
      final userId = widget.userId;
      print('this is vendor id: $vendorId');
      final ids = [widget.userId, vendorId]..sort(); // Sort the IDs
      final chatId = ids.join('_'); // Generate consistent chatId
      print('Sending message with chatId: $chatId');
      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'serviceId': _selectedService.serviceId,
        'service': _selectedService.name,
        'serviceImage': _selectedService.imgsUrl![0],
        'description': _newDescription,
        'price': _newPrice,
        'vendorId': vendorId,
        'logo': vendorData['image'],
        'companyName': vendorData['companyName'],
        'recieverId': userId,
        'createdAt': Timestamp.now(),
        "messageType": "service",
      });

      // FirebaseFirestore.instance.collection('chat').add({
      //   'text': 'Customized Service: ${_selectedService.name}',
      //   'service': _selectedService.name,
      //   'description': _newDescription,
      //   'price': _newPrice,
      //   'vendorId': vendorId,
      //   'userName': vendorData['companyName'],
      //   'userImage': vendorData['image'],
      //   'recieverId': widget.userId,
      //   'createdAt': Timestamp.now(),
      //   'messageType': 'service'
      // });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<OneService> _services = Provider.of<AllServices>(context).allServices;
    return AlertDialog(
      backgroundColor: white,
      surfaceTintColor: white,
      content: SingleChildScrollView(
        child: Container(
          width: size.width * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.02),
                Text(
                  'Create customized service',
                  style: TextStyle(
                    fontFamily: 'IrishGrover',
                    fontSize: 22,
                    color: primary,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Original service',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(87, 14, 87, 1),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: size.width * 0.7,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text('Service'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _services
                        .map((service) => DropdownMenuItem(
                              value: service,
                              child: Text(service.name!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedService = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'User Customization',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(87, 14, 87, 1),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextFormField(
                    key: ValueKey('description'),
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    validator: (description) {
                      if (description!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: 'Description ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (description) {
                      _newDescription = description!;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New price',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(87, 14, 87, 1),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextFormField(
                    key: ValueKey('price'),
                    keyboardType: TextInputType.number,
                    validator: (price) {
                      if (price!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: 'Price ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (price) {
                      _newPrice = double.parse(price!);
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                ElevatedButton(
                  onPressed: _saveCustomizedService,
                  child: Text('Create service'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
