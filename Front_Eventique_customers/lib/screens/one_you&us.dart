import 'package:eventique/color.dart';
import 'package:eventique/models/you_and_us_model.dart';
import 'package:eventique/providers/home_provider.dart';
import 'package:eventique/screens/service_details.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class YouAndUsPage extends StatefulWidget {
  static const routeName = '/you-us';

  @override
  State<YouAndUsPage> createState() => _YouAndUsPageState();
}

class _YouAndUsPageState extends State<YouAndUsPage> {
  int _current = 0;
  bool _isLoading = false;
  bool _isInit = true;
  final CarouselController _controller = CarouselController();

  Future<void> fetchDetails(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<HomeProvider>(context, listen: false)
          .findYouAndUsById(id);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final id = ModalRoute.of(context)!.settings.arguments as int;
      print(id);
      fetchDetails(id);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final youAndUsData = Provider.of<HomeProvider>(context).oneYourAndUs;
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: 'IrishGrover'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : youAndUsData == null
              ? const Center(child: Text('No data found!'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 30, 30, 0),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text:
                                      'Our customers were thrilled, describing their event as a ',
                                  style: TextStyle(
                                      // fontFamily: 'Kanit',
                                      color: primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: youAndUsData.description ?? 'perfect',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'IrishGrover',
                                      color: secondary)),
                              const TextSpan(
                                  text: ' experience ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primary)),
                            ],
                          ),
                        ),
                      ),
                      youAndUsData.imagesUrl!.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.all(24),
                              child: Stack(
                                children: <Widget>[
                                  CarouselSlider(
                                    items: youAndUsData.imagesUrl!
                                        .map((item) => ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20.0)),
                                              child: CachedNetworkImage(
                                                  width: double.infinity,
                                                  imageUrl: item,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 230, 230, 230),
                                                      ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 230, 230, 230),
                                                      )),
                                            ))
                                        .toList(),
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                        enlargeCenterPage: true,
                                        height: 347,
                                        viewportFraction: 0.8,
                                        enlargeFactor: 0.3,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                  ),
                                  Positioned(
                                    bottom: 8.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: youAndUsData.imagesUrl!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return GestureDetector(
                                          onTap: () => _controller
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: 12.0,
                                            height: 12.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 4.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (Theme.of(context)
                                                        .primaryColor)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 1.0
                                                            : 0.3)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      // const Gap(20),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                        child: Text(
                          "Services ",
                          style: TextStyle(
                              fontSize: 22,
                              color: primary,
                              fontFamily: 'IrishGrover'),
                        ),
                      ),
                      const Gap(15),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: youAndUsData.eventServices!.length,
                        itemBuilder: (context, i) {
                          final service = youAndUsData.eventServices![i];
                          return
                              // Column(
                              //   children: [
                              //     InkWell(
                              // onTap: () {
                              //   Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //       builder: (ctx) => ServiceDetails(
                              //           serviceId: service.serviceId),
                              //     ),
                              //   );
                              // },
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //           border: Border.all(
                              //             color: const Color(0xFFDB8498),
                              //           ),
                              //           borderRadius: BorderRadius.circular(10.0),
                              //         ),
                              //         height: 80,
                              //         width: 337,
                              //         child: ListTile(
                              //           title: Text(
                              //             service.name ?? '',
                              //             style: const TextStyle(),
                              //           ),
                              //           subtitle: const Text("Parfait"),
                              // leading: const Icon(Icons.cake),
                              // trailing: const Icon(
                              //   Icons.arrow_forward_ios,
                              // ),
                              //         ),
                              //       ),
                              //     ),
                              //     const Gap(8)
                              //   ],
                              // );

                              Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color(0xff662465), width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
                              color: beige,
                              shadowColor: beige,
                              surfaceTintColor: beige,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ServiceDetails(
                                          serviceId: service.serviceId),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Card(
                                        shape: const CircleBorder(
                                          side: BorderSide(
                                            color: primary,
                                            width: 1,
                                          ),
                                        ),
                                        elevation: 6,
                                        color: beige,
                                        margin: EdgeInsets.only(left: 8),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                          child: Icon(Icons.celebration),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                service.name,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    bodyMediumStyle!.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'IrishGrover',
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                service.vendorName,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: bodyMediumStyle.copyWith(
                                                  color: Color.fromRGBO(
                                                      126, 116, 126, 1),
                                                  fontFamily: 'IrishGrover',
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
