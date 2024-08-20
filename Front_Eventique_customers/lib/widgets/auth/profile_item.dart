import 'package:flutter/material.dart';
import '/color.dart';

class ProfileItem extends StatefulWidget {
  final String title;
  String userInfo;
  final String subtitle;
  final IconData iconData;
  final bool isLight;
  final Function(String)? onUpdate;
  final VoidCallback? onTap;

  ProfileItem({
    required this.title,
    required this.userInfo,
    required this.subtitle,
    required this.iconData,
    required this.isLight,
    this.onUpdate,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userInfo);
  }

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
          onTap: widget.onTap ?? null,
          isThreeLine: true,
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
                widget.title == 'Password' ? '*********' : widget.userInfo,
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
          subtitle: Text(
            widget.subtitle,
            style: TextStyle(
              fontFamily: 'CENSCBK',
              color: widget.isLight ? secondary : darkOnPrimary,
            ),
          ),
          leading: Icon(
            widget.iconData,
            color: widget.isLight ? primary : darkOnPrimary,
          ),
          trailing: widget.title == 'Name'
              ? IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: widget.isLight ? primary : Colors.grey.shade400,
                  ),
                  onPressed: () => _showEditDialog(context, widget.isLight),
                )
              : null,
          tileColor: widget.isLight ? white : darkOnPrimary,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, bool isLight) {
    showModalBottomSheet(
      backgroundColor: isLight ? white : darkBackground,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit ${widget.title}',
                style: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: widget.isLight ? secondary : darkOnPrimary,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _controller,
                style: TextStyle(
                  color: isLight ? primary : darkPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter new ${widget.title}',
                  focusColor: isLight ? primary : darkPrimary,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isLight ? Colors.grey : darkBackground),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: isLight ? primary : darkBackground),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                cursorColor: isLight ? primary : darkPrimary,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'CENSCBK',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: widget.isLight ? primary : darkOnPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.userInfo = _controller.text;
                      });
                      widget.onUpdate!(_controller.text);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'CENSCBK',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: widget.isLight ? primary : darkOnPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
