//taghreed
import 'package:eventique/providers/saved.dart';
import 'package:eventique/screens/auth_screen.dart';
import 'package:eventique/screens/saved_screen.dart';
import 'package:eventique/screens/shared_events_for_one_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/providers/auth_provider.dart';
import '/screens/profile_screen.dart';
import '/screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  Widget buildListTile(IconData icon, String title, VoidCallback tapHandeler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'CENSCBK',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary),
      ),
      onTap: tapHandeler,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userInfo = Provider.of<Auth>(context).userData;

    return Drawer(
      backgroundColor: white,
      child: Column(
        children: [
          Container(
            height: size.height / 5,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: darkBackground,
                  backgroundImage: userInfo['userImage']!.isNotEmpty
                      ? NetworkImage(userInfo['userImage']!)
                      : null,
                  child: userInfo['userImage']!.isNotEmpty
                      ? null
                      : Icon(
                          Icons.person,
                          size: 25,
                          color: white,
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userInfo['userName']!,
                      style: TextStyle(
                        color: white,
                        fontFamily: 'CENSCBK',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      userInfo['userEmail']!,
                      style: TextStyle(
                        color: white,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            Icons.person,
            'Profile',
            () {
              Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
              );
            },
          ),
          buildListTile(
            Icons.bookmarks,
            'Saved Services',
            () {
              Provider.of<Saved>(context, listen: false).fetchSaved();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => SavedServices(),
                ),
              );
            },
          ),
          buildListTile(Icons.share, 'Shared Events', () {
            Navigator.of(context)
                .pushNamed(SharedEventsForOneUserScreen.routeName);
          }),
          buildListTile(
            Icons.handshake,
            'Be A Partner',
            () {},
          ),
          buildListTile(
            Icons.settings,
            'Settings',
            () {
              Navigator.of(context).pushNamed(
                SettingsScreen.routeName,
              );
            },
          ),
          buildListTile(
            Icons.logout,
            'Logout',
            () async {
              await Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
