import 'dart:io';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';
import '/providers/auth_vendor.dart';
import '/screens/email_rest_screen.dart';
import '/screens/password_rest_screen.dart';
import '/widgets/pickers/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '/color.dart';
import '/widgets/vendor_profile/vendor_profile_item.dart';
import 'package:flutter/material.dart';

class VendorProfileScreen extends StatefulWidget {
  static const routeName = '/vendor-profile';

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  bool _isLoading = false;

  void _updateCompanyName(String newData) {
    setState(() {
      Provider.of<AuthVendor>(context, listen: false).userData['companyName'] =
          newData;
    });
    Provider.of<AuthVendor>(context, listen: false)
        .updateInfo('company_name', newData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Company Name updated successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateDescription(String newData) {
    setState(() {
      Provider.of<AuthVendor>(context, listen: false).userData['description'] =
          newData;
    });
    Provider.of<AuthVendor>(context, listen: false)
        .updateInfo('description', newData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Description updated successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updatePhoneNum(String newData) {
    setState(() {
      Provider.of<AuthVendor>(context, listen: false).userData['phone'] =
          newData;
    });
    Provider.of<AuthVendor>(context, listen: false)
        .updateInfo('phone_number', newData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Phone number updated successfully.'),
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
      final userData = Provider.of<AuthVendor>(context, listen: false).userData;
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_${userData['companyName']}_images')
          .child('${userData['email']}.jpg');
      await ref.putFile(image);
      final imageURL = await ref.getDownloadURL();
      print('$imageURL+++++++++++++++++++++++++++++++++++++++');
      Provider.of<AuthVendor>(context, listen: false)
          .updateInfo('image', imageURL);

      setState(() {
        Provider.of<AuthVendor>(context, listen: false).userData['image'] =
            imageURL;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image updated successfully.'),
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

  File? _pickedImage;

  Future<void> _showImagePickerDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Select Your Logo'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    TextButton.icon(
                      onPressed: () => _imagePick(ImageSource.gallery),
                      icon: Icon(
                        Icons.photo_library,
                      ),
                      label: Text('Gallery'),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _imagePick(ImageSource.camera),
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                  label: Text('Camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _imagePick(ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 150,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _pickedImage = File(imageFile.path);
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vendorProvider = Provider.of<AuthVendor>(context);
    final vendorInfo = vendorProvider.userData;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);

    // Debugging statements to check vendorInfo
    print(vendorInfo);

    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: 220,
              color: darkBackground,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.person,
                      color: white,
                      size: 75,
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: onPrimary,
                      child: IconButton(
                        onPressed: _showImagePickerDialog,
                        icon: Icon(
                          Icons.camera_alt,
                          size: 25,
                          color: Color.fromRGBO(255, 253, 240, 1),
                        ),
                      ),
                    ),
                  )
                ],
              )
              //
              // vendorInfo.coverImageUrl != null
              //     ? Image.network(vendorInfo.coverImageUrl!)
              //     :

              ),
          Positioned(
            top: 160,
            left: 50,
            child: UserImagePicker(
              imagePickedFn: _uploadImage,
              defaultImageUrl: vendorInfo['image'] ?? '',
              imageRadius: 60,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.36,
              left: size.width * 0.02,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  VendorProfileItem(
                    title: 'Company Name',
                    userInfo: vendorInfo['companyName'] ?? 'N/A',
                    subtitle: 'This name will be visible to other \nusers.',
                    iconData: Icons.person,
                    isLight: isLight,
                    onUpdate: _updateCompanyName,
                  ),
                  VendorProfileItem(
                    title: 'Email',
                    userInfo: vendorInfo['email'] ?? 'N/A',
                    subtitle: '',
                    iconData: Icons.email,
                    isLight: isLight,
                    onTap: _navigateToRestEmail,
                  ),
                  VendorProfileItem(
                    title: 'Password',
                    userInfo: '*********',
                    subtitle: '',
                    iconData: Icons.lock,
                    isLight: isLight,
                    onTap: _navigateToRestPassword,
                  ),
                  VendorProfileItem(
                    title: 'About',
                    userInfo: vendorInfo['description'] ?? 'N/A',
                    subtitle: '',
                    iconData: Icons.description,
                    isLight: isLight,
                    onUpdate: _updateDescription,
                  ),
                  VendorProfileItem(
                    title: 'Location',
                    userInfo:
                        '${vendorInfo['city']},${vendorInfo['country']},${vendorInfo['location']},' ??
                            'N/A',
                    subtitle: '',
                    iconData: Icons.location_on,
                    isLight: isLight,
                    //    onUpdate: _updateLocation,
                  ),
                  VendorProfileItem(
                      title: 'Working Hours',
                      userInfo: vendorInfo['days'] != null &&
                              vendorInfo['days'].isNotEmpty
                          ? vendorInfo['days'][0].toString()
                          : 'N/A',
                      subtitle: 'vendorInfo[opening]',
                      iconData: Icons.timer,
                      isLight: isLight),
                  VendorProfileItem(
                    title: 'Phone',
                    userInfo: '0${vendorInfo['phone']}',
                    subtitle: '',
                    iconData: Icons.call,
                    isLight: isLight,
                    onUpdate: _updatePhoneNum,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
