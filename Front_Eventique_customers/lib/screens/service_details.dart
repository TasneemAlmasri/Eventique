import '/color.dart';
import 'package:eventique/providers/saved.dart';
import 'package:eventique/widgets/image_slider.dart';
import 'package:eventique/widgets/my_bottom_appbar.dart';
import 'package:eventique/widgets/my_tabBar.dart';
import 'package:eventique/widgets/my_tabbarview.dart';
import 'package:eventique/providers/services_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key, required this.serviceId});
  final int serviceId;

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  bool _isSaving = false; // Add a separate loading state for saving

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.index = 0;
      Provider.of<AllServices>(context, listen: false).changeIndexforBottom(0);
    });

    _fetchData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<AllServices>(context, listen: false).fetchAllServices();
    await Provider.of<Saved>(context, listen: false).fetchSaved();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleTabSelection() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AllServices>(context, listen: false)
            .changeIndexforBottom(_tabController.index);
      }
    });
  }

  Future<void> _handleSaved() async {
    setState(() {
      _isSaving = true;
    });

    final savedProvider = Provider.of<Saved>(context, listen: false);
    bool isAdded;

    if (savedProvider.containsService(widget.serviceId)) {
      try {
        await savedProvider.delete(widget.serviceId);
        isAdded = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color.fromARGB(255, 76, 27, 75),
            content: const Text(
              'Removed From Saved',
              style: TextStyle(color: beige),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      } catch (error) {
        print("Error deleting service: $error");
        return;
      }
    } else {
      try {
        await savedProvider.add(widget.serviceId);
        isAdded = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color.fromARGB(255, 76, 27, 75),
            content: const Text(
              'Added To Saved',
              style: TextStyle(color: beige),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      } catch (error) {
        print("Error adding service: $error");
        return;
      }
    }

    await _fetchData();
    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadedService = Provider.of<AllServices>(context, listen: false)
        .findById(widget.serviceId);
    final svaedProvider = Provider.of<Saved>(context);

    if (_isLoading || _isSaving) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: primary,
          ),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: MyBottomAppBar(
        price: loadedService.price,
        serviceId: loadedService.serviceId,
        imgUrl: loadedService.imgsUrl[0],
        name: loadedService.name,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Theme(
            data: Theme.of(context).copyWith(
              useMaterial3: false,
            ),
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      useMaterial3: true,
                    ),
                    child: SliverAppBar(
                      pinned: true,
                      floating: false,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          loadedService.name,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'IrishGrover'),
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: _handleSaved,
                          icon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: svaedProvider.containsService(widget.serviceId)
                                ? const Icon(Icons.bookmark, color: primary)
                                : const Icon(Icons.bookmark_border, color: primary),
                          ),
                          tooltip: 'Add to Saved',
                        ),
                      ],
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
                    child: ImageSliderScreen(imgList: loadedService.imgsUrl),
                  ),
                  MyTabBar(tabController: _tabController),
                ];
              },
              body: MyTabBarView(
                tabController: _tabController,
                serviceId: widget.serviceId,
                description: loadedService.description,
                vendorname: loadedService.vendorName,
                serviceCategoryId: loadedService.categoryId,
              ),
            ),
          );
        },
      ),
    );
  }
}


