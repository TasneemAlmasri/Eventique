import '/color.dart';
import 'package:flutter/material.dart';

class CustomizeTile extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final String serviceImage;
  final String serviceDes;
  final String price;
  final String userName;
  final String userImage;
  final bool isMe;
  final Key key;

  const CustomizeTile(
      {required this.serviceImage,
      required this.serviceId,
      required this.serviceName,
      required this.serviceDes,
      required this.price,
      required this.userName,
      required this.userImage,
      required this.isMe,
      required this.key});

  @override
  Widget build(BuildContext context) {
    print(isMe);
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
            color: isMe ? white : Colors.grey[300],
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
                'Original service',
                style: TextStyle(
                  color: secondary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                serviceName,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Customization',
                style: TextStyle(
                  color: secondary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                serviceDes,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Price',
                style: TextStyle(
                  color: secondary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
