import '/color.dart';
import '/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatefulWidget {
  final String name;
  final String imageUrl;
  final int userId;
  ChatListItem({
    required this.name,
    required this.imageUrl,
    required this.userId,
  });

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: {
            'userId': widget.userId,
            'userName': widget.name,
            'userImageUrl': widget.imageUrl,
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 9,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: darkBackground,
              backgroundImage: widget.imageUrl.isNotEmpty
                  ? NetworkImage(widget.imageUrl)
                  : null,
              child: widget.imageUrl.isNotEmpty
                  ? null
                  : Icon(
                      Icons.person,
                      size: 25,
                      color: white,
                    ),
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: 'CENSCBK',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
