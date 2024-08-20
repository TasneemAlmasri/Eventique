import 'package:cached_network_image/cached_network_image.dart';
import '/screens/service_details.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  ServiceItem({
    super.key,
    required this.imgurl,
    required this.name,
    required this.rating,
    required this.serviceId,
  });
  final String imgurl;
  final String name;
  final double ?rating;
  final int serviceId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => ServiceDetails(serviceId: serviceId)),
        );
      },
      child: Container(
        // width: 2000,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF0),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(children: [
              //image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                    imageUrl: imgurl,
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
              //rating
              Positioned(
                  top: 8,
                  right: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffEBC25C),
                          size: 18,
                        ),
                        rating!=null?
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            color: const Color(0xffEBC25C),
                            fontSize: 14,
                          ),
                        ):
                        Container(),
                      ],
                    ),
                  ))
            ]),
            Text(
              name,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'IrishGrover',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff662465)),
              softWrap: false, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
