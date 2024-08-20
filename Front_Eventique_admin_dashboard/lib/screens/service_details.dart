import 'package:eventique_admin_dashboard/widgets/description.dart';
import 'package:eventique_admin_dashboard/widgets/image_slider.dart';
import 'package:flutter/material.dart';

import '/color.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key, required this.name, required this.vendorName, required this.description, required this.imgsUrls,required this.price });
  final String name,vendorName,description;
  final List<String>imgsUrls;
  final double price;

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
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
                      backgroundColor: Colors.white,
                      pinned: true,
                      floating: false,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          widget.name,
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
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: primary,
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
                        ImageSliderScreen(imgList: widget.imgsUrls ?? []),
                  ),
                ];
              },
              body:Description(description: widget.description,vendorName:widget.vendorName ,price: widget.price,),
            ),
          );
        },
      ),
    );
  }
}
