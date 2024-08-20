//taghreed
import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:provider/provider.dart';

import '/screens/user_profile_screen.dart';
import '/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> authenticateUser() async {
    try {
      // setState(() {
      //   _loadingPackages = true;
      // });
      // String firebaseToken =
      //     Provider.of<AuthVendor>(context, listen: false).fireToken;
      // await Provider.of<AuthVendor>(context, listen: false)
      //     .authenticateUserWithCustomToken(firebaseToken);
      // setState(() {
      //   _loadingPackages = false;
      // });
    } catch (error) {
      // setState(() {
      //   _loadingPackages = false;
      // });
      print(error);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    authenticateUser();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final int userId = routeArgs['userId'] as int;
    final String userName = routeArgs['userName'] as String;
    final String userImageUrl = routeArgs['userImageUrl'] as String;
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
                backgroundImage:
                    userImageUrl.isNotEmpty ? NetworkImage(userImageUrl) : null,
                child: userImageUrl.isNotEmpty
                    ? null
                    : Icon(
                        Icons.person,
                        size: 25,
                        color: white,
                      ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                userName,
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
              UserProfileScreen.routeName,
              arguments: userId,
            );
          },
        ),
        backgroundColor: white,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(userId),
            ),
            NewMessage(userId),
          ],
        ),
      ),
    );
  }
}
