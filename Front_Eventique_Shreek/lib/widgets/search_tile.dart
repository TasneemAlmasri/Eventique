import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique_company_app/screens/service_details.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  const SearchTile(
      {super.key,
      this.serviceId,
      required this.serviceUrl,
      required this.serviceName,
      required this.serviceCompany});
  final serviceId;
  final String serviceUrl;
  final String serviceName, serviceCompany;

  @override
  Widget build(BuildContext context) {
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    return Card(
      // shape: RoundedRectangleBorder(
      // side: const BorderSide(color: Color(0xff662465), width: 1),
      // borderRadius: BorderRadius.circular(20),
      // ),
      // margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
      color: const Color(0xFFFFFDF0),
      elevation: 0,
      child: InkWell(
        // borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ServiceDetails(serviceId: serviceId)),
          );
        },

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: serviceUrl,
                  height: 50,
                  width: 41,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyMediumStyle!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
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
