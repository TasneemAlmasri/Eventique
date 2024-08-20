import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderScreen extends StatefulWidget {
  const ImageSliderScreen(
      {super.key, required this.imgList});
  final List<String> imgList;

  @override
  _ImageSliderScreenState createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      child: Stack(
        children: <Widget>[
          CarouselSlider(
            items: widget.imgList
                .map((item) => ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child:  CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: item,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                    errorWidget: (context, url, error) => Container(
                          color: const Color.fromARGB(255, 230, 230, 230),
                        )),
                ))
                .toList(),
            carouselController: _controller,
            options: CarouselOptions(
                enlargeCenterPage: true,
                height: 347,
                viewportFraction: 1,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).primaryColor)
                            .withOpacity(_current == entry.key ? 1.0 : 0.3)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
