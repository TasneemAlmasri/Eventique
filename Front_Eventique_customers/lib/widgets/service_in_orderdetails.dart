import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique/models/service_in_order_details.dart';
import 'package:eventique/screens/customized_screen.dart';
import 'package:eventique/screens/service_details.dart';
import 'package:flutter/material.dart';

class ServiceInOrderDetailsTile extends StatelessWidget {
  const ServiceInOrderDetailsTile({super.key, required this.service});
  final ServiceInOrderDetails service;

  @override
  Widget build(BuildContext context) {
    // Themes
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xff662465), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
      color: const Color(0xFFFFFDF0),
      elevation: 0,
      child: GestureDetector(
        // borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (ctx) => 
          //     service.isCustom==null?
          //     ServiceDetails(serviceId:service.orderServiceId! ):
          //     CustomizedScreen(name: service.name, customDescription: service.customDescription!)

          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: service.imgUrl,
                  height: 84,
                  width: 66,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                ),
              ),
              // All texts
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.isCustom==null?
                        service.name:
                        '${service.name} Customized',
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyMediumStyle!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Price ',
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyMediumStyle,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${service.totalPrice.toStringAsFixed(2)} \$',
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyMediumStyle.copyWith(
                                color: Color(0xffCCA0C7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Quantity ',
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyMediumStyle,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${service.quantity}',
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyMediumStyle.copyWith(
                                color: Color(0xffCCA0C7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Status card
              Card(
                margin: const EdgeInsets.only(left: 10),
                color: service.status == 'pending'
                    ? Color(0xffCCA0C7)
                    : service.status == 'accepted'
                        ? Colors.green
                        : Color.fromARGB(205, 43, 43, 43),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    service.status,
                    style: bodyMediumStyle.copyWith(color: Color(0xFFFFFDF0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
