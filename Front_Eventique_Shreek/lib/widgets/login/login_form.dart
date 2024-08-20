//taghreed
import 'package:eventique_company_app/screens/sign_up_screens/sign_up_screen1.dart';
import 'package:flutter/material.dart';
import '/color.dart';
import '/screens/enter_email_screen.dart';

class LoginForm extends StatefulWidget {
  LoginForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  var _isVisible = false;
  String _userEmail = '';
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        context,
      );
      print(_userEmail);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: onPrimary,
                    offset: const Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              // child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    //takes size as much as needed only
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'IrishGrover',
                          fontSize: 30,
                          color: onPrimary,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15),
                          label: Text('Email'),
                          prefixIcon: Icon(Icons.email),
                          prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Please enter at least 7 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                          label: Text('Password'),
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _isVisible = !_isVisible),
                            icon: Icon(
                              _isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          suffixIconColor: Color.fromRGBO(87, 14, 87, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: _isVisible,
                        onSaved: (value) {
                          _userPassword = value!;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EnterEmailScreen.routeName);
                            },
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                color: onPrimary.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        ElevatedButton(
                          onPressed: _trySubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(87, 14, 87, 1),
                            fixedSize:
                                Size(size.width * 0.8, size.height * 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'CENSCBK',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 253, 240, 1),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!widget.isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: onPrimary),
                  ),
                  TextButton(
                    onPressed: () {
                      //navigate to sign up screens
                      Navigator.of(context).pushNamed(SignUpScreen1.routeName);
                    },
                    child: Text(
                      'Register now ',
                      style: TextStyle(color: primary),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
