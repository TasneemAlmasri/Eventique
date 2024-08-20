//taghreed
import 'dart:io';
import 'package:eventique/widgets/pickers/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import '/providers/theme_provider.dart';
import '/providers/auth_provider.dart';
import '/widgets/auth/profile_item.dart';
import '/screens/email_rest_screen.dart';
import '/screens/password_rest_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  void _updateName(String newName) {
    setState(() {
      Provider.of<Auth>(context, listen: false).userData['userName'] = newName;
    });
    Provider.of<Auth>(context, listen: false).updateUserName(newName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        content: Text('name updated successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToRestEmail() {
    Navigator.of(context).pushNamed(EmailRestScreen.routeName);
  }

  void _navigateToRestPassword() {
    Navigator.of(context).pushNamed(PasswordRestScreen.routeName);
  }

  Future<void> _uploadImage(File? image) async {
    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = Provider.of<Auth>(context, listen: false).userData;
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_${userData['userName']}_images')
          .child('${userData['userEmail']}.jpg');
      await ref.putFile(image);
      final imageURL = await ref.getDownloadURL();
      print('$imageURL+++++++++++++++++++++++++++++++++++++++');
      // Update user profile image in your backend
      Provider.of<Auth>(context, listen: false).updateUserImage(imageURL);

      setState(() {
        Provider.of<Auth>(context, listen: false).userData['userImage'] =
            imageURL;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('image updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final userInfo = Provider.of<Auth>(context).userData;
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
                    child: UserImagePicker(
                      imagePickedFn: _uploadImage,
                      defaultImageUrl: userInfo['userImage'],
                      imageRadius: 100,
                      iconRadius: 25,
                      iconSize: 25,
                    ),
                  ),
                  SizedBox(height: media.height * 0.04),
                  ProfileItem(
                    title: 'Name',
                    userInfo: userInfo['userName']!,
                    subtitle: 'This name will be visible to other \nusers.',
                    iconData: Icons.person,
                    isLight: isLight,
                    onUpdate: _updateName,
                  ),
                  SizedBox(height: media.height * 0.02),
                  ProfileItem(
                    title: 'Email',
                    userInfo: userInfo['userEmail']!,
                    subtitle: '',
                    iconData: Icons.email,
                    isLight: isLight,
                    onTap: _navigateToRestEmail,
                  ),
                  SizedBox(height: media.height * 0.02),
                  ProfileItem(
                    title: 'Password',
                    userInfo: '*********',
                    subtitle: '',
                    iconData: Icons.lock,
                    isLight: isLight,
                    onTap: _navigateToRestPassword,
                  ),
                ],
              ),
            ),
    );
  }
}
