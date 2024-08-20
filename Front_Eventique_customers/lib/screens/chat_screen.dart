import 'package:eventique/color.dart';
import 'package:eventique/screens/vendor_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final Map<String, String?> routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    final String vendorId = routeArgs['vendorId']!;
    final String vendorName = routeArgs['vendorName']!;
    final String vendorImageUrl = routeArgs['vendorImageUrl']!;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: primary,
            width: 1.6,
          ),
        ),
        title: InkWell(
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: darkBackground,
                backgroundImage: vendorImageUrl.isNotEmpty
                    ? NetworkImage(vendorImageUrl)
                    : null,
                child: vendorImageUrl.isNotEmpty
                    ? null
                    : Icon(
                        Icons.person,
                        size: 25,
                        color: white,
                      ),
              ),
              SizedBox(width: 16),
              Text(
                vendorName,
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontFamily: 'IrishGrover',
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              VendorProfileScreen.routeName,
              arguments: vendorId,
            );
          },
        ),
        backgroundColor: white,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(vendorId),
            ),
            NewMessage(vendorId),
          ],
        ),
      ),
    );
  }
}
