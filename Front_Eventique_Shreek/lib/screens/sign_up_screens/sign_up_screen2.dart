import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:eventique_company_app/screens/sign_up_screens/sign_up_screen3.dart';
import 'package:eventique_company_app/widgets/sign_up/sign_up_form2.dart';
import 'package:eventique_company_app/widgets/sign_up/upper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen2 extends StatelessWidget {
  static const routeName = '/sign_up2';
  const SignUpScreen2({super.key});
  Future<void> _saveForm2(
    String companyName,
    String registrationNum,
    String location,
    String city,
    String country,
    List<int> days,
    Map<int, TimeOfDay?> openningHours,
    Map<int, TimeOfDay?> closingHours,
    BuildContext ctx,
  ) async {
    try {
      print('Company Name: $companyName');
      print('Registration Number: $registrationNum');
      print('Location: $location');
      print('City: $city');
      print('Country: $country');
      print('days:$days');
      print('openning:$openningHours');
      print('closing:$closingHours');
      Provider.of<AuthVendor>(ctx, listen: false).updateVendorData({
        'companyName': companyName,
        'registrationNumber': registrationNum,
        'location': location,
        'city': city,
        'country': country,
        'days': days,
        'openningHours': openningHours,
        'closingHours': closingHours,
      });
      Navigator.of(ctx).pushNamed(SignUpScreen3.routeName);
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
              Upper(0.5, '2 of 4', 'Business Info'),
              SignUpForm2(_saveForm2),
            ],
          ),
        ),
      ),
    );
  }
}
