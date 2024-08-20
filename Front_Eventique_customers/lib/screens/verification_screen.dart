//taghreed
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:eventique/screens/navigation_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/models/verifications_arguments.dart';
import '/providers/auth_provider.dart';
import '/screens/auth_screen.dart';
import '/screens/new_password_screen.dart';
import '/widgets/auth/otp_field.dart';

class VerificationScreen extends StatefulWidget {
  static const routeName = '/verification_screen';

  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var _remainingSeconds = 60;
  bool correct = true;
  var _isLoading = false;
  // String verified = '';

  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  TextEditingController c4 = TextEditingController();
  TextEditingController c5 = TextEditingController();
  TextEditingController c6 = TextEditingController();

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    c6.dispose();
    super.dispose();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        // Handle timeout logic here
      }
    });
  }

  void _submitVerificationCode() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as VerificationArguments;
    String verificationCode =
        c1.text + c2.text + c3.text + c4.text + c5.text + c6.text;
    try {
      setState(() {
        _isLoading = true;
      });

      print('verification code function');
      print(verificationCode);
      if (args.type == 'signup') {
        await Provider.of<Auth>(context, listen: false)
            .signUpVerificationCode(args.email.trim(), verificationCode.trim());
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).popAndPushNamed(NavigationBarPage.routeName);
      } else if (args.type == 'forgotPassword') {
        await Provider.of<Auth>(context, listen: false)
            .forgetVerificationCode(args.email.trim(), verificationCode.trim());
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushNamed(
          NewPasswordScreen.routeName,
          arguments: args.email,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text('Sign up completed successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('Your password has been changed successfully.'),
          backgroundColor: Colors.green,
        ));
      } else if (args.type == 'resetEmail') {
        await Provider.of<Auth>(context, listen: false)
            .RestVerificationCode(args.email.trim(), verificationCode.trim());
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).popAndPushNamed(AuthScreen.routeName);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('Your email has been changed successfully.'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (error) {
      print(error.toString());
      setState(() {
        correct = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('An error occurred while sign-up. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendVerificationCode() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as VerificationArguments;
    try {
      setState(() {
        _isLoading = true;
      });

      if (args.type == 'signup') {
        // await Provider.of<Auth>(context, listen: false)
        //     .resendSignUpVerificationCode(args.email.trim());
      } else if (args.type == 'forgotPassword') {
        // await Provider.of<Auth>(context, listen: false)
        //     .resendForgetVerificationCode(args.email.trim());
      } else if (args.type == 'resetEmail') {
        // await Provider.of<Auth>(context, listen: false)
        //     .resendRestVerificationCode(args.email.trim());
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('Verification code has been resent successfully.'),
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
          content: Text(
              'An error occurred while resending the code. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args =
        ModalRoute.of(context)!.settings.arguments as VerificationArguments;

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.15,
            ),
            const Text(
              "Verification",
              style: TextStyle(
                fontFamily: 'IrishGrover',
                fontSize: 36,
                color: onPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.05,
                bottom: size.height * 0.15,
                right: size.width * 0.01,
                left: size.width * 0.01,
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    // style: TextStyle(backgroundColor: Colors.amber),
                    children: <TextSpan>[
                      const TextSpan(
                        text:
                            ' we sent you a verification code to your\n email ',
                        style: TextStyle(
                            fontFamily: 'CENSCBK',
                            fontSize: 18,
                            color: onPrimary),
                      ),
                      TextSpan(
                          text: args.email,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'CENSCBK',
                              fontWeight: FontWeight.bold,
                              color: primary)),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpTextField(
                    correct: correct, first: true, last: false, controller: c1),
                OtpTextField(
                    correct: correct,
                    first: false,
                    last: false,
                    controller: c2),
                OtpTextField(
                    correct: correct,
                    first: false,
                    last: false,
                    controller: c3),
                OtpTextField(
                    correct: correct,
                    first: false,
                    last: false,
                    controller: c4),
                OtpTextField(
                    correct: correct,
                    first: false,
                    last: false,
                    controller: c5),
                OtpTextField(
                    correct: correct, first: false, last: true, controller: c6),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Center(
                child: _remainingSeconds == 0
                    ? TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Resend code again',
                          style: TextStyle(
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: secondary,
                          ),
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          // style: TextStyle(backgroundColor: Colors.amber),
                          children: <TextSpan>[
                            const TextSpan(
                                text: ' send in  ',
                                style: TextStyle(
                                    fontFamily: 'CENSCBK',
                                    fontSize: 18,
                                    color: onPrimary)),
                            TextSpan(
                              text: '${_remainingSeconds}s',
                              style: const TextStyle(
                                  fontFamily: 'CENSCBK',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: onPrimary),
                            ),
                          ],
                        ),
                      )),
            SizedBox(
              height: size.height * 0.15,
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: _submitVerificationCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      fixedSize: Size(size.width * 0.8, size.height * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        fontFamily: 'CENSCBK',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
