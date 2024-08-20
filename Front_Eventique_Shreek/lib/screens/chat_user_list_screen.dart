import 'package:eventique_company_app/providers/auth_vendor.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/color.dart';
import '/providers/theme_provider.dart';
import '/providers/users_provider.dart';
import '/widgets/chat/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatUsersListScreen extends StatefulWidget {
  static const routeName = '/users-list';

  @override
  State<ChatUsersListScreen> createState() => _ChatUsersListScreenState();
}

class _ChatUsersListScreenState extends State<ChatUsersListScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    final vendorId = Provider.of<AuthVendor>(context)
        .userId
        .toString(); // Get current vendor ID

    Provider.of<UsersProvider>(context, listen: false)
        .fetchUsersForVendor(vendorId);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _fetchUsers();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);

    final userData = Provider.of<UsersProvider>(context).users;

    return Scaffold(
      backgroundColor: isLight ? white : darkBackground,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, i) => ChatListItem(
                name: userData[i].name!,
                userId: userData[i].id!,
                imageUrl: userData[i].imageUrl!,
              ),
              itemCount: userData.length,
            ),
    );
  }
}
