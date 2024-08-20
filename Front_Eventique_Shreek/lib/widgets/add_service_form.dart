import 'dart:io';

import 'package:eventique_company_app/color.dart';
import 'package:eventique_company_app/providers/services_provider.dart';
import 'package:eventique_company_app/widgets/pickers/multiple_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddServiceForm extends StatefulWidget {
  AddServiceForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    List<File> imagesPicked,
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
  String _serviceName = '';
  double _servicePrice = 0.0;
  int _selectedCategory = 0;
  String _description = '';
  bool _selectInPackages = false;
  List<File> _selectedImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllCategories();
  }

  void _onImagesPicked(List<File> images) {
    setState(() {
      _selectedImages = images;
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
    if (_selectedImages.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _selectedImages,
        _serviceName.trim(),
        _servicePrice,
        _selectedCategory,
        _description.trim(),
        _selectInPackages,
        context,
      );
      print(_serviceName);
      print(_servicePrice);
      print(_selectedCategory);
      print(_description);
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
              SizedBox(
                height: size.height * 0.02,
              ),
              MultiImagePicker(onImagesPicked: _onImagesPicked),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: TextFormField(
                  key: ValueKey('serviceName'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a service name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
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
                  onSaved: (value) {
                    _serviceName = value!;
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: secondary, width: 1.4),
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
                          prefixText: '\$',
                          prefixIconColor: secondary,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _servicePrice = double.parse(value!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: secondary, width: 1.4),
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
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: TextFormField(
                  key: ValueKey('description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
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
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
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
                    Text(
                      'Include in Discounted Packages',
                      style: TextStyle(
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.help_outline, color: Colors.blue),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: Text(
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
                                child: Text('Close'),
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
              SizedBox(
                height: size.height * 0.02,
              ),
              widget.isLoading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: _trySubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary.withOpacity(0.8),
                          fixedSize:
                              Size(size.width * 0.9, size.height * 0.058),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Add Service',
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
        ));
  }
}
