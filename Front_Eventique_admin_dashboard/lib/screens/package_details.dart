import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique_admin_dashboard/color.dart';
import 'package:eventique_admin_dashboard/models/one_service.dart';
import 'package:eventique_admin_dashboard/providers/packages.dart';
import 'package:eventique_admin_dashboard/screens/service_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PackageDetailsScreen extends StatelessWidget {
  final double oldPrice;
  final double newPrice;
  final int packageId;

  PackageDetailsScreen({
    super.key,
    required this.newPrice,
    required this.oldPrice,
    required this.packageId,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = size.height / 2.4;
    final double itemWidth = size.width / 7.5;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Column(
            children: [
              Container(
                height: size.height * 0.4,
                color: secondary.withOpacity(0.6),
              ),
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
                boxShadow: [
                  const BoxShadow(
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
                      'Package Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CENSCBK',
                        color: primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Old price $oldPrice , New price is $newPrice',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CENSCBK',
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 46),
                  // FutureBuilder to fetch services
                  Container(
                     height: itemHeight,
                    child: FutureBuilder(
                      future: Provider.of<Packages>(context, listen: false).fetchServicesInPackage(packageId),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Show circular progress indicator while fetching data
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.error != null) {
                          // Handle error
                          return Center(
                            child: Text('An error occurred!'),
                          );
                        } else {
                          // Display services
                          return Consumer<Packages>(
                            builder: (ctx, packageData, child) {
                              final services = packageData.packageServices;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: itemWidth,
                                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 12.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Container(
                                              color: Colors.white,
                                              width: size.width * 0.3,
                                              padding: EdgeInsets.all(16),
                                              child: ServiceDetails(
                                                name: services[index].name,
                                                vendorName: services[index].vendorName,
                                                description: services[index].description,
                                                imgsUrls: services[index].imgsUrl,
                                                price: services[index].price,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: SizedBox(
                                                height: itemHeight * 0.6,
                                                width: itemWidth * 0.7,
                                                child: CachedNetworkImage(
                                                  imageUrl: services[index].imgsUrl.isNotEmpty
                                                      ? services[index].imgsUrl[0]
                                                      : '',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    color: const Color.fromARGB(255, 242, 242, 242),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    color: const Color.fromARGB(255, 242, 242, 242),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            services[index].name,
                                            maxLines: 1,
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
                                            services[index].vendorName,
                                            maxLines: 1,
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
                              );
                            },
                          );
                        }
                      },
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
