//taghreed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/models/verifications_arguments.dart';
import '/providers/auth_provider.dart';
import '/screens/verification_screen.dart';
import '/widgets/auth/email_form.dart';

class EmailRestScreen extends StatefulWidget {
  static const routeName = '/email_rest';

  @override
  State<EmailRestScreen> createState() => _EmailRestScreenState();
}

class _EmailRestScreenState extends State<EmailRestScreen> {
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

      print('enter new email function');
      await Provider.of<Auth>(context, listen: false).emailRest(userEmail);
      setState(() {
        _isLoading = false;
      });
      //this may cause error we will
      Navigator.of(context).pushNamedAndRemoveUntil(
        VerificationScreen.routeName,
        arguments: VerificationArguments(
          email: userEmail,
          type: 'resetEmail',
        ),
        (route) => false,
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
    } catch (error) {
      print(error.toString());
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
                "Rest your email",
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
                  "Fill in your new email and we’ll send a code \nto reset your email",
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
