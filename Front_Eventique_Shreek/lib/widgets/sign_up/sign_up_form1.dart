import 'package:flutter/material.dart';
import 'dart:io';
import '../pickers/user_image_picker.dart';

class SignUpForm1 extends StatefulWidget {
  SignUpForm1(
    this.submitForm1,
  );
  final void Function(
    String vendorEmail,
    String vendorFirstName,
    String vendorLastName,
    String vendorPassword,
    String vendorConfirmPassword,
    String vendorPhone,
    File? vendorImage,
    BuildContext ctx,
  ) submitForm1;

  @override
  State<SignUpForm1> createState() => _SignUpForm1State();
}

class _SignUpForm1State extends State<SignUpForm1> {
  final _formKey = GlobalKey<FormState>();
  var _isVisible = true;
  String _vendorEmail = '';
  String _vendorFirstName = '';
  String _vendorLastName = '';
  String _vendorPhone = '';
  String _vendorPassword = '';
  String _vendorConfirmPassword = '';
  final _vendorPasswordController = TextEditingController();
  File? _vendorImage;
  void _submitImage(File? image) {
    _vendorImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_vendorImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload your logo'),
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitForm1(
        _vendorEmail.trim(),
        _vendorFirstName.trim(),
        _vendorLastName.trim(),
        _vendorPassword.trim(),
        _vendorConfirmPassword.trim(),
        _vendorPhone.trim(),
        _vendorImage,
        context,
      );
      print(_vendorEmail);
      print(_vendorFirstName + _vendorLastName);
      print(_vendorPassword);
      print(_vendorConfirmPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          UserImagePicker(
            imagePickedFn: _submitImage,
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 320,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('firstName'),
                    keyboardType: TextInputType.name,
                    validator: (firstname) {
                      if (firstname!.isEmpty || firstname.length < 4) {
                        return 'Please enter at least 4 characters';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text('First Name'),
                      prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (fName) {
                      _vendorFirstName = fName!;
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('lastName'),
                    keyboardType: TextInputType.name,
                    validator: (lastname) {
                      if (lastname!.isEmpty || lastname.length < 4) {
                        return 'Please enter at least 4 characters';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text('Last Name'),
                      prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (lName) {
                      _vendorLastName = lName!;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 320,
            child: TextFormField(
              key: ValueKey('email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                label: Text('Email'),
                isDense: true,
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (value) {
                _vendorEmail = value!;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 320,
            child: TextFormField(
              key: ValueKey('phone'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty || value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                label: Text('Phone Number'),
                isDense: true,
                prefixIcon: Icon(Icons.phone),
                prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (phone) {
                _vendorPhone = phone!;
              },
            ),
          ),
          SizedBox(height: size.width * 0.05),
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              key: ValueKey('password'),
              keyboardType: TextInputType.text,
              obscureText: _isVisible,
              controller: _vendorPasswordController,
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
                  onPressed: () => setState(() => _isVisible = !_isVisible),
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                suffixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (password) {
                _vendorPassword = password!;
              },
            ),
          ),
          SizedBox(
            height: size.width * 0.05,
          ),
          SizedBox(
            width: size.width * 0.8,
            child: TextFormField(
              key: ValueKey('confirmPassword'),
              keyboardType: TextInputType.text,
              obscureText: _isVisible,
              validator: (value) {
                if (value!.isEmpty || value.length < 7) {
                  return 'Please enter at least 7 characters';
                } else if (_vendorPasswordController.text != value) {
                  return 'Password doesn\'t match';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15),
                prefixIcon: const Icon(Icons.lock),
                prefixIconColor: Color.fromRGBO(87, 14, 87, 1),
                label: Text('Confirm Password'),
                isDense: true,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _isVisible = !_isVisible),
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                suffixIconColor: Color.fromRGBO(87, 14, 87, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (confirmationPass) {
                _vendorConfirmPassword = confirmationPass!;
              },
            ),
          ),
          SizedBox(
            height: size.width * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.08),
                child: ElevatedButton(
                  onPressed: _trySubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(87, 14, 87, 1),
                    fixedSize: Size(size.width * 0.4, size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 253, 240, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
