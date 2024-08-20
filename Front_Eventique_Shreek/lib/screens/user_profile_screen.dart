//taghreed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/providers/theme_provider.dart';
import 'package:eventique_company_app/providers/users_provider.dart';
import '/widgets/login/profile_item.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/user-profile';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final userId = ModalRoute.of(context)!.settings.arguments as int;
    final userInfo = Provider.of<UsersProvider>(context).findById(userId);
    final themeProvider = Provider.of<ThemeProvider>(context);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);
    return Scaffold(
      backgroundColor: isLight ? white : darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? white : darkBackground,
        shape: Border(
          bottom: BorderSide(
            color: isLight ? primary : white,
            width: 1.6,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Profile',
            style: TextStyle(
              color: isLight ? primary : white,
              fontSize: 30,
              fontFamily: 'IrishGrover',
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: media.height * 0.03),
                  Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      // backgroundImage: userInfo.imageUrl != null
                      //     ? NetworkImage(userInfo.imageUrl!)
                      //     : null,
                      child:
                          // userInfo.imageUrl != null
                          //     ? null
                          //     :
                          Icon(
                        Icons.person,
                        color: white,
                        size: 50,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.04),
                  ProfileItem(
                    title: 'Name',
                    userInfo: userInfo.name!,
                    iconData: Icons.person,
                    isLight: isLight,
                  ),
                  SizedBox(height: media.height * 0.02),
                  ProfileItem(
                    title: 'Email',
                    userInfo: userInfo.email!,
                    iconData: Icons.email,
                    isLight: isLight,
                  ),
                ],
              ),
            ),
    );
  }
}
