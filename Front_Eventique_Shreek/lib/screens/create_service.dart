import 'dart:io';
import 'package:eventique_company_app/providers/services_provider.dart';
import 'package:eventique_company_app/screens/navigation_bar_page.dart';
import 'package:eventique_company_app/widgets/add_service_form.dart';
import 'package:eventique_company_app/widgets/pickers/multiple_image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateService extends StatefulWidget {
  static const routeName = '/create-service';

  @override
  State<CreateService> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  bool _isLoading = false;

  Future<List<String>> _uploadImages(List<File> selectedImages) async {
    if (selectedImages.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one image')),
      );
      return [];
    }

    List<String> imageUrls = [];
    try {
      for (var image in selectedImages) {
        String fileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Services')
            .child('vendorName/$fileName');
        await storageRef.putFile(image);
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      Navigator.of(context).popAndPushNamed(NavigationBarPage.routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service has been added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      return imageUrls;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
      return [];
    }
  }

  Future<void> _addService(
    List<File> imagesPicked,
    String serviceName,
    double servicePrice,
    int selectedCat,
    String description,
    bool selectInPackages,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<String> imagesUrl = await _uploadImages(imagesPicked);
      print(imagesUrl);
      await Provider.of<ServiceProvider>(context, listen: false).addNewService(
          imagesUrl,
          serviceName,
          servicePrice,
          selectedCat,
          description,
          selectInPackages);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: beige,
        appBar: AppBar(
          backgroundColor: beige,
          title: Text(
            "Create new service",
            style: TextStyle(
                fontSize: 22.0, fontFamily: 'IrishGrover', color: primary),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Container(
              height: 4.0,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: primary,
                      width: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: AddServiceForm(_addService, _isLoading));
  }
}
