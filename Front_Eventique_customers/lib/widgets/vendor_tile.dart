import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VendorTile extends StatelessWidget {
  const VendorTile({super.key, required this.vendorname});
  final String vendorname;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 30, 24),
      child: Row(
        children: [
          // CachedNetworkImage(
          //   imageUrl:
          //       'https://i.postimg.cc/y6rkV8QR/photo-2024-04-25-23-30-27.jpg',
          //   imageBuilder: (context, imageProvider) => CircleAvatar(
          //     radius: 24,
          //     backgroundImage: imageProvider,
          //   ),
          //   placeholder: (context, url) => CircleAvatar(
          //     child: Container(
          //       color: const Color.fromARGB(255, 230, 230, 230),
          //     ),
          //   ),
          //   errorWidget: (context, url, error) => CircleAvatar(
          //     child: Container(
          //       color: const Color.fromARGB(255, 230, 230, 230),
          //     ),
          //   ),
          // ),
         const Card(
                shape: CircleBorder(
                  side: BorderSide(
                    color: primary,
                    width: 1,
                  ),
                ),
                elevation: 6,
                color: beige,
                margin: const EdgeInsets.only(left: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Icon(Icons.storefront),
                ),
              ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vendor',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Color.fromARGB(255, 226, 147, 168))),
              Text(
                vendorname,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.commentDots,
                size: 22.0, color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
