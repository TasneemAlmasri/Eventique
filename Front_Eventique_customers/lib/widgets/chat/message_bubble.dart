import 'package:eventique/color.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;
  final Key key;

  MessageBubble(this.message, this.userName, this.userImage, this.isMe,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(
              userImage,
            ),
          ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(10),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
            ),
            color: isMe ? lightPurple : Colors.grey[300],
          ),
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                message,
                style: TextStyle(
                  color: white,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
