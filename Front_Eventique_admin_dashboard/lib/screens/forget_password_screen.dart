import '/widgets/circular_shape.dart';
import '/widgets/login_form.dart';
import 'package:flutter/material.dart';
import '/color.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget-pass';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _isLoading = false;
  Future<void> _submitLoginForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // await Provider.of<AuthVendor>(context, listen: false)
      //     .login(email, password);
      // Navigator.of(ctx).popAndPushNamed(MianScreen.routeName);
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('sign in completed successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
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
                      'Welcome To \nEvenTique Admin Dashboard',
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
            child: LoginForm(_submitLoginForm, _isLoading),
          ),
        ],
      ),
    );
  }
}
