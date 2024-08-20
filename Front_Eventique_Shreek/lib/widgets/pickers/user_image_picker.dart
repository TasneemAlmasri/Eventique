import 'dart:io';
import 'package:eventique_company_app/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File? imagePicked) imagePickedFn;
  final String? defaultImageUrl;
  final double imageRadius;
  final double iconRadius;
  final double iconSize;

  UserImagePicker({
    required this.imagePickedFn,
    this.defaultImageUrl,
    this.imageRadius = 50.0,
    this.iconRadius = 18.0,
    this.iconSize = 18.0,
  });

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
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
    widget.imagePickedFn(_pickedImage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: widget.imageRadius,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!)
              : (widget.defaultImageUrl != null)
                  ? NetworkImage(widget.defaultImageUrl!) as ImageProvider
                  : null,
          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
          child: _pickedImage != null || widget.defaultImageUrl != null
              ? null
              : Icon(
                  Icons.person,
                  size: widget.imageRadius,
                  color: Color.fromRGBO(255, 253, 240, 1),
                ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: CircleAvatar(
            radius: widget.iconRadius,
            backgroundColor: onPrimary,
            child: IconButton(
              onPressed: _showImagePickerDialog,
              icon: Icon(
                Icons.camera_alt,
                size: widget.iconSize,
                color: Color.fromRGBO(255, 253, 240, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
