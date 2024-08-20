import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventique/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventique/color.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  final String vendorId;

  const NewMessage(this.vendorId, {super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final provider = Provider.of<Auth>(context, listen: false);
    final userData = provider.userData;
    final userId = provider.userId.toString();
    print('this is user id: $userId');
    final ids = [userId, widget.vendorId]..sort(); // Sort the IDs
    final chatId = ids.join('_'); // Generate consistent chatId
    print('Sending message with chatId: $chatId');
    print(
        'text: $_enteredMessage \n createdAt: ${Timestamp.now()},userId: $userId,recieverId:${widget.vendorId},userName: ${userData['userName']},userImage: ${userData['userImage']}, messageType: normal');
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': userId,
        'recieverId': widget.vendorId,
        'userName': userData['userName'],
        'userImage': userData['userImage'],
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
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: primary,
              decoration: InputDecoration(
                hintText: 'Send a message ...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primary),
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
            icon: const Icon(
              Icons.send,
            ),
            color: primary,
          ),
        ],
      ),
    );
  }
}
