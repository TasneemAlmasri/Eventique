import '/models/verifications_arguments.dart';
import '/providers/admin_provider.dart';
import '/widgets/enter_email_form.dart';
import '/widgets/verification_form.dart';
import 'package:provider/provider.dart';
import '/widgets/circular_shape.dart';
import 'package:flutter/material.dart';
import '/color.dart';

class EnterEmailScreen extends StatefulWidget {
  static const routeName = '/enter-email';
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  bool _isLoading = false;
  String userEmail = '';

  void _submitEmailForm(
    String userEmail,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('enter email function');
      await Provider.of<AdminProvider>(context, listen: false)
          .emailForgetPassword(userEmail);
      print('in forgetpassword screen email:$userEmail');

      Navigator.of(context).pushNamedAndRemoveUntil(
        VerificationForm.routeName,
        (route) => false,
        arguments: VerificationArguments(
          email: userEmail,
          type: 'forgotPassword',
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

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
            child: EmailForm(_submitEmailForm, _isLoading),
          ),
        ],
      ),
    );
  }
}
