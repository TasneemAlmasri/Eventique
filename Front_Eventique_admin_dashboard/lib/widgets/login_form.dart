//taghreed
import 'package:eventique_admin_dashboard/screens/enter_email_screen.dart';
import 'package:flutter/material.dart';
import '/color.dart';

class LoginForm extends StatefulWidget {
  const LoginForm(this.submitFn, this.isLoading, {super.key});
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
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
                    SizedBox(
                      width: 380,
                      child: TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          label: const Text('Email'),
                          prefixIcon: const Icon(Icons.email),
                          prefixIconColor: const Color.fromRGBO(87, 14, 87, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    SizedBox(
                      width: 380,
                      child: TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please enter at least 6 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: const Color.fromRGBO(87, 14, 87, 1),
                          label: const Text('Password'),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _isVisible = !_isVisible),
                            icon: Icon(
                              _isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          suffixIconColor: const Color.fromRGBO(87, 14, 87, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: _isVisible,
                        onSaved: (value) {
                          _userPassword = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 380,
                      child: Row(
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
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    if (widget.isLoading)
                      const CircularProgressIndicator(
                        color: primary,
                      ),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(87, 14, 87, 1),
                          fixedSize: const Size(380, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
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
          ],
        ),
      ),
    );
  }
}
