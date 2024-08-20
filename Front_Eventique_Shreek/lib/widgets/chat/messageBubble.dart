import '/color.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  var message;
  var userName;
  var userImage;
  bool isMe;
  final key;
  MessageBubble(this.message, this.userName, this.userImage, this.isMe,
      {this.key});

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
          width: 140,
          child: Column(
            children: [
              Text(
                userName,
                style: TextStyle(color: onPrimary),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                message,
                style: TextStyle(
                  color: white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
