import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:eventique_company_app/screens/sign_up_screens/sign_up_screen4.dart';
import 'package:eventique_company_app/widgets/sign_up/upper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/sign_up/sign_up_form3.dart';

class SignUpScreen3 extends StatelessWidget {
  static const routeName = '/sign_up3';

  Future<void> _saveForm3(
    List categories,
    List eventsTypes,
    String description,
    BuildContext ctx,
  ) async {
    try {
      Provider.of<AuthVendor>(ctx, listen: false).updateVendorData({
        'eventTypeId': eventsTypes as List<int>,
        'servicesId': categories as List<int>,
        'description': description,
      });
      Navigator.of(ctx).pushNamed(SignUpScreen4.routeName);
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 253, 240, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Upper(0.75, '3 of 4', 'Service Info'),
              SignUpForm3(_saveForm3),
            ],
          ),
        ),
      ),
    );
  }
}
