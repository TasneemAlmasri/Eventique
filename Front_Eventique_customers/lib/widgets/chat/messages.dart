import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventique/color.dart';
import 'package:eventique/providers/auth_provider.dart';
import 'package:eventique/widgets/chat/customize_tile.dart';
import 'package:eventique/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  final String vendorId;

  const Messages(this.vendorId, {super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId.toString();
    final chatId = userId + '_' + vendorId;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('An error occurred, please try again later.'),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data == null) {
          return const Center(
            child: Text(
              'No messages yet.',
              style: TextStyle(
                fontFamily: 'CENSCBK',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primary,
              ),
            ),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        if (chatDocs.isEmpty) {
          return const Center(
            child: Text(
              'Start a new chat.',
              style: TextStyle(
                fontFamily: 'CENSCBK',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primary,
              ),
            ),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) {
            if (chatDocs[i]['messageType'] == 'normal')
              return MessageBubble(
                chatDocs[i]['text'],
                chatDocs[i]['userName'],
                chatDocs[i]['userImage'],
                chatDocs[i].data().containsKey('userId') &&
                    chatDocs[i]['userId'] == userId,
                key: ValueKey(chatDocs[i].id),
              );
            if (chatDocs[i]['messageType'] == 'service')
                return CustomizeTile(
                  serviceImage: chatDocs[i]['serviceImage'],
                  serviceId: (chatDocs[i]['serviceId']).toString(),
                  serviceName: chatDocs[i]['service'],
                  serviceDes: chatDocs[i]['description'],
                  price: (chatDocs[i]['price']).toString(),
                  userName: chatDocs[i]['companyName'],
                  userImage: chatDocs[i]['logo'],
                  isMe: chatDocs[i].data().containsKey('recieverId') &&
                      chatDocs[i]['recieverId'] ==
                          userId, // Check if sender is user
                  key: ValueKey(chatDocs[i].id));
           
          },
        );
      },
    );
  }
}
