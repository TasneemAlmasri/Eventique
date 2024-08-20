import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique/color.dart';
import 'package:eventique/screens/service_details.dart';
import 'package:eventique/providers/carts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/saved.dart';

class ServiceItem extends StatelessWidget {
  ServiceItem(
      {super.key,
      required this.imgurl,
      required this.name,
      required this.vendorName,
      required this.rating,
      required this.serviceId,
      this.fromSaved});
  final String imgurl;
  final String name, vendorName;
  final double? rating;
  final int serviceId;
  bool? fromSaved;

  @override
  Widget build(BuildContext context) {
    // Themes
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    final TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    final svaedProvider = Provider.of<Saved>(context, listen: false);

//couple of lines below to handle the case where user add to cart from inside the cart itself(from the add circle)
//he will be directed to the grid then to service details,but when going back ,he will go the the cart immediately not the grid
    final cartProvider = Provider.of<Carts>(context, listen: false);

    return GestureDetector(
      onTap: () {
        if (cartProvider.chosenEventId!=-1) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ServiceDetails(serviceId: serviceId)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ServiceDetails(serviceId: serviceId)),
          );
        }
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
                  top: fromSaved != null ? -6 : 8,
                  right: fromSaved != null ? -16 : 5,
                  child: fromSaved != null
                      ? TextButton(
                          onPressed: () {
                            svaedProvider.delete(serviceId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 76, 27, 75),
                                content: Text(
                                  'Removed from Saved',
                                  style: TextStyle(
                                    color: beige,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.bookmark,
                            color: primary,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
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
                                style: bodyMediumStyle!.copyWith(
                                  color: const Color(0xffEBC25C),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ))
            ]),
            Text(
              name,
              style: bodyMediumStyle,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              vendorName,
              style: bodySmallStyle!.copyWith(fontWeight: FontWeight.w500),
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
