import 'package:flutter/material.dart';
import '/color.dart';

class ProfileItem extends StatefulWidget {
  final String title;
  String userInfo;

  final IconData iconData;
  final bool isLight;

  ProfileItem({
    required this.title,
    required this.userInfo,
    required this.iconData,
    required this.isLight,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isLight ? white : darkBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: widget.isLight ? white : darkBackground,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'CENSCBK',
                  color: widget.isLight ? secondary : darkOnPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.userInfo,
                style: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: widget.isLight ? primary : darkOnPrimary,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          leading: Icon(
            widget.iconData,
            color: widget.isLight ? primary : darkOnPrimary,
          ),
          tileColor: widget.isLight ? white : darkOnPrimary,
        ),
      ),
    );
  }
}
