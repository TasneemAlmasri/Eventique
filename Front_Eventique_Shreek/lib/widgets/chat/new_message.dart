import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:eventique_company_app/widgets/chat/create_customized_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';

class NewMessage extends StatefulWidget {
  final int userId;

  NewMessage(this.userId);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final provider = Provider.of<AuthVendor>(context, listen: false);
    final userData = provider.userData;
    final vendorId = provider.userId;
    print('this is vendor id: $vendorId');
    final ids = [widget.userId, vendorId]..sort(); // Sort the IDs
    final chatId = ids.join('_'); // Generate consistent chatId
    print('Sending message with chatId: $chatId');
    print(
        'text: $_enteredMessage \n createdAt: ${Timestamp.now()},userId: $vendorId,recieverId:${widget.userId},userName: ${userData['userName']},userImage: ${userData['userImage']}, messageType: normal');
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': vendorId,
        'recieverId': widget.userId,
        'userName': userData['companyName'],
        'userImage': userData['image'],
        'messageType': 'normal',
      },
    );
    final snap = await FirebaseFirestore.instance.collection('chats').get();
    print(snap.docs.length);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateCustomizedService(widget.userId);
                },
              );
            },
            icon: Icon(
              Icons.add_box_rounded,
              color: primary,
            ),
            iconSize: 36,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Send a message ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
            ),
            color: primary,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
