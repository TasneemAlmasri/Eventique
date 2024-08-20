import 'package:flutter/material.dart';
import '/color.dart';

class OtpTextField extends StatelessWidget {
  bool first;
  bool last;
  bool correct;
  TextEditingController controller;
  OtpTextField({
    required this.correct,
    required this.first,
    required this.last,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.001),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: correct ? onPrimary : Colors.red, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          constraints: BoxConstraints(
            maxWidth: size.width / 8,
            maxHeight: size.width / 8,
          ),
        ),
        onChanged: (digit) {
          if (digit.isNotEmpty && last == false) {
            FocusScope.of(context).nextFocus();
          } else if (digit.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
