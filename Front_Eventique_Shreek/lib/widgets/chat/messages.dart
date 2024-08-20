import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventique_company_app/widgets/chat/customize_tile.dart';
import '/color.dart';
import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'messageBubble.dart';

class Messages extends StatelessWidget {
  final int userId; // This is the userId who is chatting with the vendor

  const Messages(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    final vendorId =
        Provider.of<AuthVendor>(context, listen: false).userId.toString();
    final chatId = userId.toString() + '_' + vendorId;

    return StreamBuilder(
      // Access the chat messages for the specific user-vendor chat session
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

        // Build the list of messages
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) {
            // Check message type
            if (chatDocs[i]['messageType'] == 'normal') {
              return MessageBubble(
                chatDocs[i]['text'], // Text of the message
                chatDocs[i]['userName'], // Sender's name
                chatDocs[i]['userImage'], // Sender's image
                chatDocs[i].data().containsKey('userId') &&
                    chatDocs[i]['userId'] == userId, // Check if sender is user
                key: ValueKey(chatDocs[i].id), // Unique key for each message
              );
            } else if (chatDocs[i]['messageType'] == 'service') {
              // Handle 'service' type messages
              return CustomizeTile(
                  serviceImage: chatDocs[i]['serviceImage'],
                  serviceId: (chatDocs[i]['serviceId']).toString(),
                  serviceName: chatDocs[i]['service'],
                  serviceDes: chatDocs[i]['description'],
                  price: (chatDocs[i]['price']).toString(),
                  userName: chatDocs[i]['companyName'],
                  userImage: chatDocs[i]['logo'],
                  isMe: chatDocs[i].data().containsKey('vendorId') &&
                      chatDocs[i]['vendorId'] ==
                          vendorId, // Check if sender is user
                  key: ValueKey(chatDocs[i].id));
              // return ListTile(
              //   title: Text('Service: ${chatDocs[i]['service']}'),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Description: ${chatDocs[i]['description']}'),
              //       Text('Price: \$${chatDocs[i]['price']}'),
              //     ],
              //   ),
              // );
            } else {
              // Handle other message types if necessary
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
