import 'package:eventique_admin_dashboard/color.dart';
import 'package:eventique_admin_dashboard/providers/categories_event_type.dart';
import 'package:eventique_admin_dashboard/providers/packages.dart';
import 'package:eventique_admin_dashboard/screens/create_package.dart';
import 'package:eventique_admin_dashboard/screens/package_details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class AddToApp extends StatefulWidget {
  @override
  _AddToAppState createState() => _AddToAppState();
}

class _AddToAppState extends State<AddToApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch all data
      await Provider.of<Packages>(context, listen: false)
          .fetchAvailablePackages();
      await Provider.of<CategoriesAndTypes>(context, listen: false)
          .fetchCategories();
      await Provider.of<CategoriesAndTypes>(context, listen: false)
          .fetchEventTypes();
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddCategoryDialog(BuildContext context, String entered) {
    TextEditingController _textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add $entered',
            style: TextStyle(
              color: primary,
              fontFamily: 'CENSCBK',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Enter $entered ',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: primary)),
            ),
            TextButton(
              onPressed: () async {
                if (_textController.text.trim().isNotEmpty) {
                  try {
                    if (entered == 'Category') {
                      print('i am in the if statement');
                      await Provider.of<CategoriesAndTypes>(context, listen: false)
                          .addCategory(_textController.text);
                    } else {
                      await Provider.of<CategoriesAndTypes>(context,
                              listen: false)
                          .addEventType(_textController.text);
                    }
                    Navigator.of(context)
                        .pop(); // Close the dialog after successful addition
                  } catch (error) {
                    // Handle errors, show a snackbar, etc.
                    print('Error adding event type: $error');
                  }
                }
              },
              child: const Text('Add', style: TextStyle(color: primary)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePackage(BuildContext context, int packageId) async {
    // Show a loading indicator while deleting
    final loadingDialog = showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (ctx) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call the provider to delete the service
      await Provider.of<Packages>(context, listen: false)
          .deletePackage(packageId);

      // Close the loading indicator
      Navigator.of(context).pop(); // Dismiss the CircularProgressIndicator

      // Optionally show a confirmation snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package deleted successfully')),
      );
    } catch (error) {
      // Dismiss the loading indicator
      Navigator.of(context).pop();

      // Handle error (e.g., show a snackbar or dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting service')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesProvider = Provider.of<Packages>(context);
    final categoriesAndTypesPro = Provider.of<CategoriesAndTypes>(context);
    final availablePackages = packagesProvider.availablePackages;
    final categories = categoriesAndTypesPro.categories;
    final eventTypes = categoriesAndTypesPro.eventTypes;
    final size = MediaQuery.of(context).size;
    int totalImages = 8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 0, 0),
            child: Text(
              'Available Packages',
              style: TextStyle(
                color: primary,
                fontSize: 24,
                fontFamily: 'IrishGrover',
              ),
            ),
          ),
          Container(
            height: size.height * 0.3,
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availablePackages.length + 1,
                    itemBuilder: (context, index) {
                      if (index < availablePackages.length) {
                        return Container(
                          width: size.width * 0.16,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => PackageDetailsScreen(
                                            
                                            newPrice: availablePackages[index]
                                                    .newPrice ??
                                                100,
                                            oldPrice: availablePackages[index]
                                                    .oldPrice ??
                                                115,
                                            packageId:
                                                availablePackages[index].id ??
                                                    1,
                                          )));
                            },
                            onDoubleTap: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Delete package?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );

                              if (shouldDelete == true) {
                                await _deletePackage(
                                    context, availablePackages[index].id ?? 1);
                              }
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'images/${index % totalImages}.jpg', // Use modulo to cycle through images
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      print(
                                          'Failed to load image: ${index % totalImages}.jpg');
                                      return Container(
                                        color: const Color.fromARGB(
                                            255, 230, 230, 230),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                    bottom: 16,
                                    left: 94,
                                    child: Text(
                                      availablePackages[index].name ??
                                          'Birthday',
                                      style: TextStyle(
                                          color: primary,
                                          fontFamily: 'CENSCBK',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: size.width * 0.16,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => CreatePackage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 241, 241, 241),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: secondary,
                                size: 32,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
          // Bottom
          Expanded(
            child: Row(
              children: [
                // Left
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: primary,
                            fontSize: 24,
                            fontFamily: 'IrishGrover',
                          ),
                        ),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(right: size.width * 0.1),
                                child: ListView.builder(
                                  itemCount: categories.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < categories.length) {
                                      return ListTile(
                                        title: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 12, 12, 12),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  248, 248, 248, 1),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            categories[index].name,
                                            style: const TextStyle(
                                              color: primary,
                                              fontFamily: 'CENSCBK',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          _showAddCategoryDialog(
                                              context, 'Category');
                                        },
                                        child: ListTile(
                                          title: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                32, 12, 12, 12),
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    248, 248, 248, 1),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Icon(Icons.add,
                                                color: secondary),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                // Right
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Event Type',
                          style: TextStyle(
                            color: primary,
                            fontSize: 24,
                            fontFamily: 'IrishGrover',
                          ),
                        ),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(right: size.width * 0.1),
                                child: ListView.builder(
                                  itemCount: eventTypes.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < eventTypes.length) {
                                      return ListTile(
                                        title: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 12, 12, 12),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  248, 248, 248, 1),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            eventTypes[index].name,
                                            style: const TextStyle(
                                              color: primary,
                                              fontFamily: 'CENSCBK',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ListTile(
                                        title: GestureDetector(
                                          onTap: () {
                                            _showAddCategoryDialog(
                                                context, 'Event Type');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                32, 12, 12, 12),
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    248, 248, 248, 1),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Icon(Icons.add,
                                                color: secondary),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
