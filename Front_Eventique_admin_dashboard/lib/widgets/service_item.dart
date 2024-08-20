import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique_admin_dashboard/color.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  ServiceItem({
    super.key,
    required this.imgurl,
    required this.name,
    required this.vendorName,
    required this.rating,
    required this.serviceId,
  });

  final String imgurl;
  final String name, vendorName;
  final double? rating;
  final int serviceId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (ctx) => ServiceDetails(serviceId: serviceId)),
        // );
      },
      child: Container(
        width: size.width * 0.3,
        height: size.width * 0.3,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      width: size.width * 0.2,
                      height: size.width * 0.3,
                      imageUrl: imgurl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color.fromARGB(255, 230, 230, 230),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color.fromARGB(255, 230, 230, 230),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: primary,
                    fontSize: 14, // Adjust font size as needed
                  ),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: primary,
                    fontSize: 12, // Adjust font size as needed
                  ),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                    Text(
                      rating != null ? rating!.toStringAsFixed(1) : '',
                      style: TextStyle(
                        color: const Color(0xffEBC25C),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
