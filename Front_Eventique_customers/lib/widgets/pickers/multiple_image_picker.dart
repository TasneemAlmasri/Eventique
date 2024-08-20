//taghreed
import 'dart:io';
import 'package:eventique/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MultiImagePicker extends StatefulWidget {
  final void Function(List<String>) onImagesUploaded;

  MultiImagePicker({required this.onImagesUploaded});

  @override
  _MultiImagePickerState createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles == null) {
      return;
    }
    setState(() {
      if (_selectedImages.length + pickedFiles.length <= 5) {
        _selectedImages.addAll(
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can select a maximum of 5 images')),
        );
      }
    });
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least three images')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<String> imageUrls = [];
    try {
      for (var image in _selectedImages) {
        String fileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Share_Events')
            .child('EventName/$fileName');
        await storageRef.putFile(image);
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      widget.onImagesUploaded(imageUrls);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Images uploaded successfully')),
      );
      setState(() {
        _selectedImages = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.42,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: white,
            border: Border.all(color: secondary, width: 2),
          ),
          child: Center(
            child: _selectedImages.isEmpty
                ? TextButton(
                    onPressed: _pickImages,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 30,
                          color: secondary,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Pick Images',
                          style: TextStyle(
                            fontFamily: 'IrishGrover',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: _selectedImages.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (ctx, index) {
                            return GridTile(
                              child: Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                              ),
                              header: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (_selectedImages.length < 5)
                        TextButton(
                          onPressed: _pickImages,
                          child: Text(
                            'Pick More Images',
                            style: TextStyle(
                              fontFamily: 'IrishGrover',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: secondary,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _uploadImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondary.withOpacity(0.8),
                  fixedSize: Size(size.width * 0.4, size.height * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Upload',
                  style: TextStyle(
                    fontFamily: 'IrishGrover',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ),
      ],
    );
  }
}
