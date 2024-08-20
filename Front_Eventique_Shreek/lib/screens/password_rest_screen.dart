//taghreed
import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:eventique_company_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/providers/theme_provider.dart';
import '/widgets/vendor_profile/password_rest_form.dart';

class PasswordRestScreen extends StatefulWidget {
  static const routeName = '/password-rest';

  @override
  State<PasswordRestScreen> createState() => _PasswordRestScreenState();
}

class _PasswordRestScreenState extends State<PasswordRestScreen> {
  bool _isLoading = false;

  void _submitRestPasswordForm(
    String oldPassword,
    String password,
    String confirmPassword,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('new password function');
      await Provider.of<AuthVendor>(context, listen: false)
          .passwordRest(oldPassword, password, confirmPassword);
      setState(() {
        _isLoading = false;
      });
      //this may cause error we will
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully.'),
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
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);
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
                "Rest your password",
                style: TextStyle(
                  fontSize: 34,
                  color: onPrimary,
                  fontFamily: 'IrishGrover',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.05,
                  bottom: size.height * 0.1,
                  right: size.width * 0.01,
                  left: size.width * 0.01,
                ),
                child: Text(
                  "Please fill your old password and then \nenter your new password",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'CENSCBK',
                    color: onPrimary,
                  ),
                ),
              ),
              PasswordRestForm(_submitRestPasswordForm, _isLoading, isLight),
            ],
          ),
        ),
      ),
    );
  }
}
