import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventique/providers/home_provider.dart';
import 'package:eventique/screens/create_event.dart';
import 'package:eventique/screens/one_package_details.dart';
import 'package:eventique/screens/one_you&us.dart';
import '/color.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    await Provider.of<HomeProvider>(context, listen: false).fetchPackages();
    await Provider.of<HomeProvider>(context, listen: false).fetchYouAndUs();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeProvider = Provider.of<HomeProvider>(context);
    final loadedPackages = homeProvider.allPackages;
    final loadedYouAndUs = homeProvider.allYouAndUs;
    int totalImages = 8;

    return Scaffold(
      backgroundColor: white,
      body: FutureBuilder(
        future: _fetchDataFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: size.height * 0.04),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0, 0.99],
                            colors: [
                              primary,
                              Color.fromARGB(255, 255, 224, 248)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        width: size.width * 0.9,
                        height: size.height * 0.1,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CreateEvent();
                              },
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " Create Your Event",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 253, 240),
                                    fontSize: 20,
                                    fontFamily: 'IrishGrover'),
                              ),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //start the packages
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Packages",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'IrishGrover',
                            color: primary,
                          )),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Everything you need in one place at discounted prices.",
                        style: TextStyle(
                            fontFamily: 'IrishGrover',
                            fontSize: 16,
                            color: primary),
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.04,
                    ),
                    //here..............................................................................................................

                    SizedBox(
                      height: size.width * 0.4,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: loadedPackages.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  OnePackageDetailsPage.routeName,
                                  arguments: loadedPackages[i].id,
                                );
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/images/${i % totalImages}.jpg', // Use modulo to cycle through images
                                      width: size.width * 0.55,
                                      height: size.width * 0.5,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        print(
                                            'Failed to load image: ${i % totalImages}.jpg');
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
                                        loadedPackages[i].name ?? 'Birthday',
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
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.06,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "You & Us",
                        style: TextStyle(
                          fontSize: 24,
                          color: primary,
                          fontFamily: 'IrishGrover',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.02,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Your Joy Our Craft !",
                        style: TextStyle(
                          fontSize: 16,
                          color: primary,
                          fontFamily: 'IrishGrover',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.06,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: loadedYouAndUs.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  YouAndUsPage.routeName,
                                  arguments: loadedYouAndUs[index].id);
                            },
                            child: Card(
                              color: beige,
                              surfaceTintColor: beige,
                              shadowColor: beige,
                              child: Container(
                                height: 129,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      loadedYouAndUs[index].imagesUrl![0],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: Color.fromRGBO(
                                            238, 234, 238, 0.636),
                                      ),
                                      height: 135,
                                      width: size.width * 0.4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "It was ..",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: primary,
                                            ),
                                          ),
                                          const Gap(15),
                                          Text(
                                            loadedYouAndUs[index].description!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: primary,
                                                fontFamily: 'IrishGrover'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
