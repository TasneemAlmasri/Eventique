import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique_admin_dashboard/color.dart';
import 'package:eventique_admin_dashboard/screens/service_details.dart';
import 'package:eventique_admin_dashboard/providers/packages.dart'; // Assuming you have this provider setup
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePackage extends StatefulWidget {
  CreatePackage({super.key});

  @override
  _CreatePackageState createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  List<int> selectedServiceIds = [];
  bool isMultiSelectMode = false;
  bool isLoading = true;
  bool isCreatingPackage = false;

  @override
  void initState() {
    super.initState();
    _fetchPackagableServices();
  }

  Future<void> _fetchPackagableServices() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Packages>(context, listen: false)
          .fetchPackagableServices();
    } catch (error) {
      print("Error fetching packagable services: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createPackage() async {
    setState(() {
      isCreatingPackage = true;
    });

    try {
      await Provider.of<Packages>(context, listen: false)
          .createPackage(1, selectedServiceIds);
      setState(() {
        selectedServiceIds.clear();
        isMultiSelectMode = false;
      });
    } catch (error) {
      print("Error creating package: $error");
    } finally {
      setState(() {
        isCreatingPackage = false;
      });
    }
  }

  void _toggleSelection(int serviceId) {
    setState(() {
      if (selectedServiceIds.contains(serviceId)) {
        selectedServiceIds.remove(serviceId);
      } else {
        selectedServiceIds.add(serviceId);
      }

      // If no services are selected, exit multi-select mode
      if (selectedServiceIds.isEmpty) {
        isMultiSelectMode = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<Packages>(context).packagableServices;
    final size = MediaQuery.of(context).size;
    final double itemHeight =
        size.height / 2.4; // Retain your original item height
    final double itemWidth = size.width / 7.5;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Column(
            children: [
              Container(
                  height: size.height * 0.4, color: secondary.withOpacity(0.6)),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Foreground Container
          Positioned(
            top: size.height * 0.15,
            left: 20,
            right: 20,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              height: size.height * 0.7,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12.0,
                    offset: Offset(0, 0),
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Create a new package',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CENSCBK',
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 46),
                  // Show loading indicator while data is being fetched
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primary,
                          ),
                        )
                      : services.isEmpty
                          ? const Center(
                              child: Text(
                                "No services available.",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primary,
                                ),
                              ),
                            )
                          : Container(
                              height: itemHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  final service = services[index];
                                  final isSelected = selectedServiceIds
                                      .contains(service.serviceId);

                                  return GestureDetector(
                                    onTap: () {
                                      if (isMultiSelectMode) {
                                        _toggleSelection(service.serviceId);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Container(
                                              color: Colors.white,
                                              width: size.width * 0.3,
                                              padding: const EdgeInsets.all(16),
                                              child: ServiceDetails(
                                                name: service.name,
                                                vendorName: service.vendorName,
                                                description:
                                                    service.description,
                                                imgsUrls: service.imgsUrl,
                                                price: service.price,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    onDoubleTap: () {
                                      setState(() {
                                        isMultiSelectMode = true;
                                        selectedServiceIds
                                            .add(service.serviceId);
                                      });
                                    },
                                    child: Container(
                                      width: itemWidth,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 18),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? secondary.withOpacity(0.3)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 12.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: SizedBox(
                                                height: itemHeight * 0.6,
                                                width: itemWidth * 0.7,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      service.imgsUrl.isNotEmpty
                                                          ? service.imgsUrl[0]
                                                          : '',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color: const Color.fromARGB(
                                                        255, 242, 242, 242),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: const Color.fromARGB(
                                                        255, 242, 242, 242),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            service.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'CENSCBK',
                                              color: primary,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            service.vendorName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: primary,
                                              fontFamily: 'CENSCBK',
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                  const SizedBox(height: 20),
                  Center(
                    child: isCreatingPackage
                        ? const CircularProgressIndicator(
                            color: primary,
                          )
                        : ElevatedButton(
                            onPressed: selectedServiceIds.isEmpty
                                ? null
                                : _createPackage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Create Package',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'CENSCBK',
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
