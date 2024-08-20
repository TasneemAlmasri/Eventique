import 'package:flutter/material.dart';

class Upper extends StatelessWidget {
  var value;
  String progress = '';
  String title = '';
  Upper(this.value, this.progress, this.title);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            height: 75,
            child: Stack(
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(
                    value: value,
                    backgroundColor: Color.fromRGBO(87, 14, 87, 0.25),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(231, 145, 165, 1),
                    ),
                    strokeWidth: 8,
                  ),
                ),
                Center(
                  child: Text(
                    progress,
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(87, 14, 87, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.075,
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'CENSCBK',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(87, 14, 87, 1),
            ),
          ),
        ],
      ),
    );
  }
}
