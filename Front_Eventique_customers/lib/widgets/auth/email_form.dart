import 'package:flutter/material.dart';
import '/color.dart';

class EmailForm extends StatefulWidget {
  const EmailForm(this.submitFn, this.isLoading, {super.key});
  final bool isLoading;
  final void Function(
    String email,
    BuildContext ctx,
  ) submitFn;

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formkey = GlobalKey<FormState>();

  String _userEmail = '';

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        context,
      );
      print(_userEmail);
    }
    //use those values to send out auth request...
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
                height: size.height * 0.2,
              ),
              if (widget.isLoading) const CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _trySubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(87, 14, 87, 1),
                    fixedSize: Size(size.width * 0.8, size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 253, 240, 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
