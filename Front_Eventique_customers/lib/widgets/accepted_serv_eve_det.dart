import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique/models/service_in_order_details.dart';
import 'package:flutter/material.dart';

class AcceptedServices extends StatelessWidget {
  const AcceptedServices({super.key, required this.acceptedList});
  final List<ServiceInOrderDetails> acceptedList;

  @override
  Widget build(BuildContext context) {
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    return //container
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.34, //500
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFFDF0),
          boxShadow: [
            // Top-left shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: Offset(5, 5),
              blurRadius: 2,
              spreadRadius: -3, // Negative to simulate inner shadow
            ),
            // Bottom-right shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: Offset(-5, -5),
              blurRadius: 2,
              spreadRadius: -3, // Negative to simulate inner shadow
            ),
          ],
        ),

        child: acceptedList.isEmpty
            ? Center(
                child: Text(
                  'No Accepted Servicea Yet',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontFamily: 'IrishGrover',
                        fontSize: 22,
                        color: const Color.fromARGB(255, 227, 181, 193),
                      ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: acceptedList.length,
                itemBuilder: (ctx, i) => Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xff662465), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
                  color: const Color(0xFFFFFDF0),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: acceptedList[i].imgUrl,
                            height: 80,
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
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                   acceptedList[i].isCustom==null?
                                  acceptedList[i].name:
                                  '${acceptedList[i].name} Customized',
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Price:',
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: bodyMediumStyle,
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      flex: 2,
                                      child: Text(
                                        '${acceptedList[i].totalPrice.toStringAsFixed(1)}\$',
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: bodyMediumStyle.copyWith(
                                          color: Color(0xffCCA0C7),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Quantity: ',
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: bodyMediumStyle,
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        '${acceptedList[i].quantity}',
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
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
