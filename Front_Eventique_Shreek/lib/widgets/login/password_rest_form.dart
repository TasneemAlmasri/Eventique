import '/color.dart';
import 'package:flutter/material.dart';

class PasswordRestForm extends StatefulWidget {
  PasswordRestForm(this.submitFn, this.isLoading, this.isLight);
  final bool isLoading;
  final bool isLight;
  final void Function(
    String oldPassword,
    String password,
    String confirmPassword,
    BuildContext ctx,
  ) submitFn;

  @override
  State<PasswordRestForm> createState() => _PasswordRestFormState();
}

class _PasswordRestFormState extends State<PasswordRestForm> {
  final _formkey = GlobalKey<FormState>();
  var _isVisible = true;
  String _oldPassword = '';
  String _userPassword = '';
  String _confirmPassword = '';
  final _passwordController = TextEditingController();

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _oldPassword.trim(),
        _userPassword.trim(),
        _confirmPassword.trim(),
        context,
      );
      print(_oldPassword);
      print(_userPassword);
      print(_confirmPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                width: size.width * 0.8,
                child: TextFormField(
                  key: ValueKey('oldPassword'),
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
                    label: Text('Old Password'),
                    isDense: true,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _isVisible = !_isVisible),
                      icon: Icon(
                        _isVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    suffixIconColor: Color.fromRGBO(87, 14, 87, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: widget.isLight ? Colors.grey : darkBackground),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 2,
                          color: widget.isLight ? primary : darkBackground),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  cursorColor: widget.isLight ? primary : darkBackground,
                  obscureText: _isVisible,
                  onSaved: (value) {
                    _oldPassword = value!;
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: TextFormField(
                  controller: _passwordController,
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
                      onPressed: () => setState(() => _isVisible = !_isVisible),
                      icon: Icon(
                        _isVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    suffixIconColor: Color.fromRGBO(87, 14, 87, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: widget.isLight ? Colors.grey : darkBackground),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 2,
                          color: widget.isLight ? primary : darkBackground),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  cursorColor: widget.isLight ? primary : darkBackground,
                  obscureText: _isVisible,
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
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
                    } else if (_passwordController.text != value) {
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
                        _isVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    suffixIconColor: Color.fromRGBO(87, 14, 87, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: widget.isLight ? primary : darkBackground),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: widget.isLight ? Colors.grey : darkBackground),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 2,
                          color: widget.isLight ? primary : darkBackground),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  cursorColor: widget.isLight ? primary : darkPrimary,
                  onSaved: (password) {
                    _confirmPassword = password!;
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.15,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _trySubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(87, 14, 87, 1),
                    fixedSize: Size(size.width * 0.8, size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Rest',
                    style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
