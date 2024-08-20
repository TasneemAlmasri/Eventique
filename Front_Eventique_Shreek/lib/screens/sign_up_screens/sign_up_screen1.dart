import 'dart:io';
import 'package:eventique_company_app/color.dart';
import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:eventique_company_app/screens/login_screen.dart';
import 'package:eventique_company_app/screens/sign_up_screens/sign_up_screen2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/sign_up/sign_up_form1.dart';
import '/widgets/sign_up/upper.dart';

class SignUpScreen1 extends StatelessWidget {
  static const routeName = '/sign-up1';
  Future<void> _saveForm1(
    String vendorEmail,
    String vendorFirstName,
    String vendorLastName,
    String vendorPassword,
    String vendorConfirmPassword,
    String vendorPhone,
    File? vendorImage,
    BuildContext ctx,
  ) async {
    try {
      String? imageURL;
      if (vendorImage != null) {
        imageURL = await uploadImageToFireStorage(
          vendorFirstName,
          vendorLastName,
          vendorEmail,
          vendorImage,
          imageURL,
        );
        print(imageURL);
      }
      Provider.of<AuthVendor>(ctx, listen: false).updateVendorData({
        'firstName': vendorFirstName,
        'lastName': vendorLastName,
        'email': vendorEmail,
        'password': vendorPassword,
        'confirmPassword': vendorConfirmPassword,
        'phone': vendorPhone,
        'image': imageURL,
      });

      // Provider.of<AuthVendor>(ctx, listen: false).updateVendorData(Vendor(
      //   firstName: vendorFirstName,
      //   lastName: vendorLastName,
      //   email: vendorEmail,
      //   password: vendorPassword,
      //   confirmPassword: vendorConfirmPassword,
      //   phone: vendorPhone,
      //   image: imageURL,
      // ));
      Navigator.of(ctx).pushNamed(SignUpScreen2.routeName);
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

  Future<String?> uploadImageToFireStorage(
    String vendorFirstName,
    String vendorLastName,
    String vendorEmail,
    File vendorImage,
    String? imageURL,
  ) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('vendor_${vendorFirstName + vendorLastName}_image')
        .child('$vendorEmail.jpg');
    await ref.putFile(vendorImage);
    imageURL = await ref.getDownloadURL();
    return imageURL;
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
              Upper(0.25, '1 of 4', 'Contact Info'),
              SignUpForm1(
                _saveForm1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: onPrimary),
                  ),
                  TextButton(
                    onPressed: () {
                      //navigate to sign up screens
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      'Login now',
                      style: TextStyle(
                          color: primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
