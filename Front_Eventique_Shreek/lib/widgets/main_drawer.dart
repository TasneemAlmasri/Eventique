//taghreed
import 'package:eventique_company_app/providers/reviews.dart';

import '/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import 'package:eventique_company_app/providers/auth_vendor.dart';
import '../screens/vendor_profile_screen.dart';
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
    final vendorInfo = Provider.of<AuthVendor>(context).userData;
    final reviewsProvider = Provider.of<Reviews>(context);

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
                  backgroundImage: vendorInfo['image']!.isNotEmpty
                      ? NetworkImage(vendorInfo['image']!)
                      : null,
                  child: vendorInfo['image']!.isNotEmpty
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
                      vendorInfo['companyName']!,
                      style: TextStyle(
                        color: white,
                        fontFamily: 'CENSCBK',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      vendorInfo['email']!,
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
                VendorProfileScreen.routeName,
              );
            },
          ),
          buildListTile(
            Icons.handshake,
            'Contract',
            () async {
              const fileName = 'terms and condition.pdf';
              
              // Call the download function
             await reviewsProvider.downloadPdf(fileName);
              // await downloadPdf( fileName);
            },
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
              await Provider.of<AuthVendor>(context, listen: false).logout();
              Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
