import 'package:eventique_admin_dashboard/providers/admin_provider.dart';
import 'package:eventique_admin_dashboard/screens/main_screen.dart';
import 'package:provider/provider.dart';

import '/widgets/circular_shape.dart';
import '/widgets/login_form.dart';
import 'package:flutter/material.dart';
import '/color.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

      await Provider.of<AdminProvider>(context, listen: false)
          .login(email, password);
      setState(() {
        _isLoading = false;
      });

      Navigator.of(ctx).popAndPushNamed(MainScreen.routeName);
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Login completed successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print(error.toString());
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
