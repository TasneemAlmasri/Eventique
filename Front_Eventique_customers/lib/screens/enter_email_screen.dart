//taghreed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/models/verifications_arguments.dart';
import '/providers/auth_provider.dart';
import '/screens/verification_screen.dart';
import '/widgets/auth/email_form.dart';

class EnterEmailScreen extends StatefulWidget {
  static const routeName = '/enter_email';

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
      await Provider.of<Auth>(context, listen: false)
          .emailForgetPassword(userEmail);
      print('in forgetpassword screen email:$userEmail');
      //this may cause error we will
      Navigator.of(context).pushNamedAndRemoveUntil(
        VerificationScreen.routeName,
        arguments: VerificationArguments(
          email: userEmail,
          type: 'forgotPassword',
        ),
        (route) => false,
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.15,
              ),
              Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: onPrimary,
                    fontFamily: 'IrishGrover'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.05,
                  bottom: size.height * 0.1,
                  right: size.width * 0.01,
                  left: size.width * 0.01,
                ),
                child: Text(
                  "Fill in your email and we’ll send a code to \nreset your password ",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'CENSCBK',
                    color: onPrimary,
                  ),
                ),
              ),
              EmailForm(_submitEmailForm, _isLoading)
            ],
          ),
        ),
      ),
    );
  }
}
