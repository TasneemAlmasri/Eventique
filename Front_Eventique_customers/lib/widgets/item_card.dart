//noor
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique/screens/service_details.dart';
import 'package:flutter/material.dart';
import '/color.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.height,
    required this.width,
    required this.firsttext,
    required this.secondtext,
    required this.image,
    required this.serviceId,
    required this.color,
  }) : super(key: key);
  final double height;
  final double width;

  final String firsttext;
  final String secondtext;
  final String image;
  final int serviceId;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => ServiceDetails(serviceId: serviceId)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                    imageUrl: image,
                    height: 176,
                    width: 139,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                    errorWidget: (context, url, error) => Container(
                          color: const Color.fromARGB(255, 230, 230, 230),
                        )),
              ),
              Text(
                firsttext,
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                secondtext,
                style: TextStyle(color: primary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
