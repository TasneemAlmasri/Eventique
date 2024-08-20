import 'dart:io';
import 'package:eventique_company_app/providers/services_list.dart';
import 'package:eventique_company_app/providers/services_provider.dart';
import 'package:eventique_company_app/widgets/pickers/multiple_image_picker.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditService extends StatefulWidget {
  const EditService({
    super.key,
    required this.imagesPicked,
    required this.existingImageUrls,
    required this.serviceName,
    required this.servicePrice,
    required this.selectedCat,
    required this.description,
    required this.selectInPackages,
    required this.serviceId,
  });
  final List<File> imagesPicked;
  final List<String> existingImageUrls;
  final String serviceName;
  final double servicePrice;
  final int selectedCat;
  final String description;
  final bool selectInPackages;
  final int serviceId;

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  bool _isLoading = false;

  Future<List<String>> _uploadImages(List<File> selectedImages) async {
    print(widget.existingImageUrls.length);
    // Check if the total number of images is at least 3
    if ((selectedImages.length + widget.existingImageUrls.length) < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully')),
      );
      return imageUrls;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
      return [];
    }
  }

  Future<void> _editService(
    List<File> imagesPicked,
    List<String> existingImageUrls,
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
      List<String> newImagesUrl = await _uploadImages(imagesPicked);
      List<String> allImageUrls = [...existingImageUrls, ...newImagesUrl];
      await Provider.of<AllServices>(context, listen: false).editService(
          allImageUrls,
          serviceName,
          servicePrice,
          selectedCat,
          description,
          selectInPackages,
          widget.serviceId);
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
          title: const Text(
            "Edit Service",
            style: TextStyle(
                fontSize: 22.0, fontFamily: 'IrishGrover', color: primary),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              height: 4.0,
              alignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(
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
        body: AddServiceForm(
          _editService,
          _isLoading,
          description: widget.description,
          imagesPicked: widget.imagesPicked,
          existingImageUrls: widget.existingImageUrls,
          selectInPackages: widget.selectInPackages,
          selectedCat: widget.selectedCat,
          serviceName: widget.serviceName,
          servicePrice: widget.servicePrice,
        ));
  }
}

class AddServiceForm extends StatefulWidget {
  const AddServiceForm(this.submitFn, this.isLoading,
      {super.key,
      required this.imagesPicked,
      this.existingImageUrls,
      required this.serviceName,
      required this.servicePrice,
      required this.selectedCat,
      required this.description,
      required this.selectInPackages});

  final List<File> imagesPicked;
  final List<String>? existingImageUrls;
  final String serviceName;
  final double servicePrice;
  final int selectedCat;
  final String description;
  final bool selectInPackages;

  final bool isLoading;
  final void Function(
    List<File> imagesPicked,
    List<String> existingImageUrls,
    String serviceName,
    double servicePrice,
    int selectedCat,
    String description,
    bool selectInPackages,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loadingCat = false;

  late TextEditingController _serviceNameController;
  late TextEditingController _servicePriceController;
  late TextEditingController _descriptionController;
  int _selectedCategory = 0;
  bool _selectInPackages = false;
  List<File> _selectedImages = [];
  List<String> _existingImageUrls = [];

  @override
  void initState() {
    _serviceNameController = TextEditingController(text: widget.serviceName);
    _servicePriceController =
        TextEditingController(text: widget.servicePrice.toString());
    _descriptionController = TextEditingController(text: widget.description);
    _selectedCategory = widget.selectedCat;
    _selectInPackages = widget.selectInPackages;
    _selectedImages = widget.imagesPicked;
    _existingImageUrls = widget.existingImageUrls ?? [];
    super.initState();
    fetchAllCategories();
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onImagesPicked(List<File> images) {
    setState(() {
      _selectedImages = images;
    });
  }

  void _onRemoveExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  Future<void> fetchAllCategories() async {
    try {
      setState(() {
        _loadingCat = true;
      });
      await Provider.of<ServiceProvider>(context, listen: false)
          .getCategories();
      setState(() {
        _loadingCat = false;
      });
    } catch (error) {
      setState(() {
        _loadingCat = false;
      });
      print(error);
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // Check if the total number of images (selected + existing) is at least 3
    if ((_selectedImages.length + _existingImageUrls.length) < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _selectedImages,
        _existingImageUrls,
        _serviceNameController.text.trim(),
        double.parse(_servicePriceController.text),
        _selectedCategory,
        _descriptionController.text.trim(),
        _selectInPackages,
        context,
      );
      print(_serviceNameController.text);
      print(_servicePriceController.text);
      print(_selectedCategory);
      print(_descriptionController.text);
      print(_selectInPackages);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final _servicesCategory =
        Provider.of<ServiceProvider>(context).allCategories;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            MultiImagePicker(
              onImagesPicked: _onImagesPicked,
              existingImageUrls:
                  _existingImageUrls.isNotEmpty ? _existingImageUrls : null,
              onRemoveExistingImage:
                  _existingImageUrls.isNotEmpty ? _onRemoveExistingImage : null,
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              width: size.width * 0.9,
              child: TextFormField(
                controller: _serviceNameController,
                key: const ValueKey('serviceName'),
                validator: (value) {
                  if (value!.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a service name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary, width: 1.4),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary, width: 2),
                  ),
                  labelText: 'Service Name',
                  labelStyle: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondary,
                  ),
                ),
                cursorColor: Colors.grey,
                style: const TextStyle(
                    color: primary, fontWeight: FontWeight.bold),
                onSaved: (value) {
                  _serviceNameController.text = value!;
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              width: size.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _servicePriceController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondary, width: 1.4),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondary, width: 2),
                        ),
                        labelText: 'Service Price',
                        labelStyle: TextStyle(
                          fontFamily: 'CENSCBK',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: secondary,
                        ),
                        prefixText: '\$ ',
                        prefixIconColor: secondary,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null ||
                            double.tryParse(value)! <= 0) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          color: primary, fontWeight: FontWeight.bold),
                      onSaved: (value) {
                        _servicePriceController.text = value!;
                      },
                    ),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondary, width: 1.4),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondary, width: 2),
                        ),
                        labelText: 'Service Category',
                        labelStyle: TextStyle(
                          fontFamily: 'CENSCBK',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: secondary,
                        ),
                        iconColor: secondary,
                      ),
                      items: _servicesCategory.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedCategory = value!;
                      },
                      validator: (value) {
                        if (value == null || value <= 0) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedCategory = value!;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              width: size.width * 0.9,
              child: TextFormField(
                controller: _descriptionController,
                key: const ValueKey('description'),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary, width: 1.4),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary, width: 2),
                  ),
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondary,
                  ),
                ),
                style: const TextStyle(
                    color: primary, fontWeight: FontWeight.bold),
                onSaved: (value) {
                  _descriptionController.text = value!;
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              width: size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _selectInPackages,
                    onChanged: (value) {
                      setState(() {
                        _selectInPackages = value!;
                      });
                    },
                  ),
                  const Text(
                    'Include in Discounted Packages',
                    style: TextStyle(
                      fontFamily: 'CENSCBK',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          content: const Text(
                            'Check this box if you\'d like to\noffer this service at a discounted \nrate as part of our exclusive \npackage deals.\nThis can increase your service\'s \nvisibility and attract more customers.\nThe discount will be a fixed 5%\noff the listed price. ',
                            style: TextStyle(
                              fontFamily: 'CENSCBK',
                              fontSize: 16,
                              color: primary,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                          backgroundColor: white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            widget.isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: _trySubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary.withOpacity(0.8),
                        fixedSize: Size(size.width * 0.9, size.height * 0.058),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Edit Service',
                        style: TextStyle(
                          fontFamily: 'IrishGrover',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
