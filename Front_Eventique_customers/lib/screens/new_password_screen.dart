//taghreed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/providers/auth_provider.dart';
import '/screens/auth_screen.dart';
import '/widgets/auth/new_password_form.dart';

class NewPasswordScreen extends StatefulWidget {
  static const routeName = '/new_password';

  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _isLoading = false;
  void _submitNewPasswordForm(
    String password,
    String confirmPassword,
    BuildContext ctx,
  ) async {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    try {
      setState(() {
        _isLoading = true;
      });

      print('new password function');
      await Provider.of<Auth>(context, listen: false)
          .newPassword(email, password, confirmPassword);
      //this may cause error we will
      Navigator.of(context).pushNamedAndRemoveUntil(
        AuthScreen.routeName,
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
                "Create New password",
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
                  "Please enter your new password",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'CENSCBK',
                    color: onPrimary,
                  ),
                ),
              ),
              NewPasswordForm(_submitNewPasswordForm, _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
