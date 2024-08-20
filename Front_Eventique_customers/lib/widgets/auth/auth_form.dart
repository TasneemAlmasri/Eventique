//taghreed
import 'dart:io';
import 'package:flutter/material.dart';
import '/color.dart';
import '/screens/enter_email_screen.dart';
import '/widgets/auth/my_divider.dart';
import '/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {super.key});
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    String confirmPassword,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isVisible = false;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  String _confirmPassword = '';
  final _passwordController = TextEditingController();
  File? _userImage;
  void _submitImage(File? image) {
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text('Please upload an image'),
        ),
      );
      return;
    }
    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _confirmPassword.trim(),
        _userImage,
        _isLogin,
        context,
      );
      print(_userEmail);
      print(_userName);
      print(_userPassword);
      print(_confirmPassword);
    }
    //use those values to send out auth request...
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
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: white,
                boxShadow: const [
                  BoxShadow(
                    color: onPrimary,
                    offset: Offset(
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
                        _isLogin ? "Login" : "SignUp",
                        style: const TextStyle(
                          fontFamily: 'IrishGrover',
                          fontSize: 30,
                          color: onPrimary,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      if (!_isLogin)
                        UserImagePicker(imagePickedFn: _submitImage),
                      if (!_isLogin)
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            label: const Text('Username'),
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor:
                                const Color.fromRGBO(87, 14, 87, 1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onSaved: (value) {
                            _userName = value!;
                          },
                        ),
                      if (!_isLogin)
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      TextFormField(
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
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Please enter at least 7 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: const Color.fromRGBO(87, 14, 87, 1),
                          label: const Text('Password'),
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
                      if (!_isLogin)
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('confirmPassword'),
                          keyboardType: TextInputType.text,
                          obscureText: _isVisible,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Please enter at least 7 characters';
                            } else if (_passwordController.text != value) {
                              return 'Password doesn\'t match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            prefixIcon: const Icon(Icons.lock),
                            prefixIconColor:
                                const Color.fromRGBO(87, 14, 87, 1),
                            label: const Text('Confirm Password'),
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
                            suffixIconColor:
                                const Color.fromRGBO(87, 14, 87, 1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onSaved: (password) {
                            _confirmPassword = password!;
                          },
                        ),
                      if (!_isLogin)
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      if (_isLogin)
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
                      if (widget.isLoading)
                        const CircularProgressIndicator(
                          color: primary,
                        ),
                      if (!widget.isLoading)
                        ElevatedButton(
                          onPressed: _trySubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(87, 14, 87, 1),
                            fixedSize:
                                Size(size.width * 0.8, size.height * 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _isLogin ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                              fontFamily: 'CENSCBK',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 253, 240, 1),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      const MyDivider(),
                      SizedBox(
                        height: size.height * 0.02,
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
                  Text(_isLogin
                      ? 'Don\'t have an account?'
                      : 'Already have an account? '),
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          _isLogin = !_isLogin;
                        },
                      );
                    },
                    child: Text(
                      _isLogin ? 'Register now ' : 'Login now ',
                      style: TextStyle(
                        color: primary,
                      ),
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
