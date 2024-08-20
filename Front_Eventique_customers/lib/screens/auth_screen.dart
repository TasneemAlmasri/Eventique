//taghreed
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:eventique/screens/navigation_bar_page.dart';
import '/color.dart';
import '/providers/auth_provider.dart';
import '/models/verifications_arguments.dart';
import '/screens/verification_screen.dart';
import '/widgets/auth/auth_form.dart';
import '/widgets/auth/circular_shape.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  Future<void> _submitAuthForm(
    String email,
    String username,
    String password,
    String confirmPassword,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        await Provider.of<Auth>(context, listen: false).login(email, password);
        Navigator.of(context).popAndPushNamed(NavigationBarPage.routeName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text('sign in completed successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        //this is the code to upload an image to fire storage
        String? imageURL;
        if (image != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_${username}_image')
              .child('$email.jpg');
          await ref.putFile(image);
          imageURL = await ref.getDownloadURL();
          print(imageURL);
        }

        await Provider.of<Auth>(context, listen: false).signUp(
          imageURL ?? '',
          username,
          email,
          password,
          confirmPassword,
        );

        Navigator.of(context).popAndPushNamed(
          VerificationScreen.routeName,
          arguments: VerificationArguments(
            email: email,
            type: 'signup',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text('OTP code sended successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.75,
              width: double.infinity,
              color: primary,
            ),
          ),
          AuthForm(_submitAuthForm, _isLoading),
        ],
      ),
    );
  }
}
