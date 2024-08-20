import 'package:eventique_company_app/screens/create_service.dart';
import 'package:eventique_company_app/screens/edit_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/color.dart';
import '/providers/services_list.dart';
import '/providers/services_provider.dart';
import '/widgets/image_slider.dart';
import '/widgets/my_tabBar.dart';
import '/widgets/my_tabbarview.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key, required this.serviceId});
  final int serviceId;

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Provider.of<ServiceProvider>(context, listen: false)
          .getCategories();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network Error';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: beige,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: primary,
            color: beige,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return const Scaffold(
        backgroundColor: beige,
        body: Center(
          child: Text('Network Error'),
        ),
      );
    }

    final loadedService = Provider.of<AllServices>(context, listen: false)
        .findById(widget.serviceId);
    final _servicesCategory =
        Provider.of<ServiceProvider>(context).allCategories;

    return Scaffold(
      backgroundColor: beige,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Theme(
            data: Theme.of(context).copyWith(
              useMaterial3: false, // Disable Material 3 for NestedScrollView
            ),
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      useMaterial3: true, // Enable Material 3 for SliverAppBar
                    ),
                    child: SliverAppBar(
                      actions: [
                        PopupMenuButton(
                          shadowColor: beige,
                          color: beige,
                          surfaceTintColor: beige,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => EditService(
                                          serviceId: loadedService.serviceId!,
                                          description:
                                              loadedService.description!,
                                          imagesPicked: [],
                                          selectInPackages: loadedService
                                              .isDiscountedPackages!,
                                          selectedCat:
                                              loadedService.categoryId!,
                                          serviceName: loadedService.name!,
                                          servicePrice: loadedService.price!,
                                          existingImageUrls:
                                              loadedService.imgsUrl!,
                                        )),
                                  ),
                                );
                              },
                              child: const Text('Edit',
                                  style: TextStyle(color: primary)),
                            ),
                            PopupMenuItem(
                              onTap: () async {
                                await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: const Color(0xFFFFFDF0),
                                    content: const Text(
                                      'Are you sure you want to delete this service?',
                                      style: TextStyle(
                                          color: primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('No',
                                            style: TextStyle(
                                                color: primary,
                                                fontWeight: FontWeight.w500)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Yes',
                                            style: TextStyle(
                                              color: primary,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        onPressed: () {
                                          Provider.of<AllServices>(context,
                                                  listen: false)
                                              .deleteService(widget.serviceId);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 76, 27, 75),
                                              content: Text(
                                                'deleted successfully',
                                                style: TextStyle(
                                                  color: beige,
                                                ),
                                              ),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Delete',
                                  style: TextStyle(color: primary)),
                            ),
                          ],
                        )
                      ],
                      backgroundColor: beige,
                      pinned: true,
                      floating: false,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          loadedService.name!,
                          style: const TextStyle(
                              fontFamily: 'IrishGrover',
                              fontSize: 22,
                              color: primary),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(4.0),
                        child: Container(
                          height: 4.0,
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child:
                        ImageSliderScreen(imgList: loadedService.imgsUrl ?? []),
                  ),
                  MyTabBar(tabController: _tabController),
                ];
              },
              body: MyTabBarView(
                tabController: _tabController,
                serviceId: widget.serviceId,
                description: loadedService.description!,
                price: loadedService.price!,
                category: _servicesCategory
                    .firstWhere(
                        (element) => element.id == loadedService.categoryId)
                    .category,
                isDiscounted: loadedService.isDiscountedPackages!,
                isVisisble: loadedService.isActivated!,
              ),
            ),
          );
        },
      ),
    );
  }
}
