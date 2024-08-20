import '/screens/login_screen.dart';

import '/providers/auth_vendor.dart';
import 'package:provider/provider.dart';

import '/widgets/sign_up/upper.dart';
import '/widgets/sign_up/sign_up_form4.dart';

import 'package:flutter/material.dart';

class SignUpScreen4 extends StatefulWidget {
  static const routeName = '/sign_up4';

  @override
  State<SignUpScreen4> createState() => _SignUpScreen4State();
}

class _SignUpScreen4State extends State<SignUpScreen4> {
  bool _isLoading = false;

  Future<void> _submitAllForms() async {
    final vendorData = Provider.of<AuthVendor>(context, listen: false).userData;

    // Debugging prints
    print('First Name: ${vendorData['firstName']}');
    print('Last Name: ${vendorData['lastName']}');
    print('Email: ${vendorData['email']}');
    print('Phone: ${vendorData['phone']}');
    print('Company Name: ${vendorData['companyName']}');
    print('Registration Number: ${vendorData['registrationNumber']}');
    print('Location: ${vendorData['location']}');
    print('City: ${vendorData['city']}');
    print('Country: ${vendorData['country']}');
    print('Description: ${vendorData['description']}');
    print('Accept Privacy: ${vendorData['acceptPrivacy']}');
    print('Services ID: ${vendorData['servicesId'].toString()}');
    print('Event Type ID: ${vendorData['eventTypeId'].toString()}');
    print('Days: ${vendorData['days'].join(', ')}');
    vendorData['openningHours'].forEach((key, value) {
      print('Opening Hours - $key: $value');
    });
    vendorData['closingHours'].forEach((key, value) {
      print('Closing Hours - $key: $value');
    });

    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthVendor>(context, listen: false).signUp();
      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Registration Successful'),
          content: Text(
            'Your company has been registered successfully. '
            'You will be notified when your registration is accepted by the admin. '
            'You cannot login until the admin accepts your request.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                Navigator.of(context).popAndPushNamed(
                    LoginScreen.routeName); // Navigate to login screen
              },
            )
          ],
        ),
      );
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
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
              Upper(1.0, '4 of 4', 'Conditions'),
              SignUpForm4(_submitAllForms, _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
