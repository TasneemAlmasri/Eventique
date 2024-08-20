import '/widgets/verification_form.dart';
import '/widgets/circular_shape.dart';
import 'package:flutter/material.dart';
import '/color.dart';

class VerificationScreen extends StatefulWidget {
  static const routeName = '/verification-screen';
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                color: primary,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Fill in your email and we’ll send a code to \nreset your password ",
                      style: TextStyle(
                        color: white,
                        fontSize: 24.0,
                        fontFamily: 'CENSCBK',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: VerificationForm(),
          ),
        ],
      ),
    );
  }
}
