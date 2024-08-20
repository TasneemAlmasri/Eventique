import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpForm4 extends StatefulWidget {
  bool isLoading;
  void Function() submitAllForms;
  SignUpForm4(this.submitAllForms, this.isLoading);

  @override
  State<SignUpForm4> createState() => _SignUpForm4State();
}

class _SignUpForm4State extends State<SignUpForm4> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Terms and Conditions for Vendors',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(87, 14, 87, 1),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '1. Eligibility:\n'
              '- You must be 18 years of age or older to use this app.\n'
              '- You must be a legitimate business owner or authorized representative of a business.\n'
              '- Your business must be legally registered and operating in compliance with all applicable laws and regulations.\n\n'
              '2. Vendor Responsibilities:\n'
              '- You must provide accurate and up-to-date information about your business, including contact details, product or service offerings, and pricing.\n'
              '- You must respond to customer inquiries and orders in a timely and professional manner.\n'
              '- You must fulfill customer orders in a timely and satisfactory manner, in accordance with the terms and conditions agreed upon with the customer.\n'
              '- You must maintain high-quality standards for your products or services and customer service.\n'
              '- You must comply with all applicable laws and regulations, including those related to taxation, labor, and consumer protection.\n\n'
              '3. App Usage:\n'
              '- You must use the app only for its intended purpose of managing your business and interacting with customers.\n'
              '- You must not use the app for any illegal, unethical, or fraudulent activities.\n'
              '- You must not share your login credentials with any unauthorized person.\n'
              '- You must respect the privacy and intellectual property rights of other users and the app provider.\n\n'
              '4. Suspension and Termination:\n'
              '- The app provider reserves the right to suspend or terminate your access to the app if you violate these terms and conditions or engage in any harmful or unethical behavior.\n'
              '- The app provider may also suspend or terminate your access if it determines that your business is no longer operating in compliance with applicable laws and regulations.\n\n'
              '5. Liability and Indemnification:\n'
              '- The app provider is not responsible for any damages or losses you may incur as a result of using the app or relying on the information provided by other users.\n'
              '- You agree to indemnify and hold the app provider harmless from any claims, damages, or liabilities arising from your use of the app or your business activities.\n\n'
              '6. Modifications:\n'
              '- The app provider reserves the right to modify these terms and conditions at any time without prior notice.\n'
              '- It is your responsibility to review the terms and conditions periodically and ensure compliance.',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(
            width: size.width * 0.8,
            child: Row(
              children: [
                Checkbox(
                  activeColor: Color.fromRGBO(87, 14, 87, 1),
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Text('I agree to the terms and conditions'),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(42, 44, 87, 0.46),
                  fixedSize: Size(size.width * 0.36, size.height * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 253, 240, 1),
                  ),
                ),
              ),
              widget.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isChecked ? widget.submitAllForms : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(87, 14, 87, 1),
                        fixedSize: Size(size.width * 0.36, size.height * 0.06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'CENSCBK',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 253, 240, 1),
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
