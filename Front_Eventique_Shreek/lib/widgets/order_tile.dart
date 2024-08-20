import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique_company_app/color.dart';
import 'package:eventique_company_app/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatefulWidget {
  OrderTile(
      {super.key,
      this.fromProcessed,
      required this.serviceName,
      required this.orderedBy,
      required this.quantity,
      required this.dueDate,
      this.isCustomized,
      this.customDescription,
      required this.totalPrice,
      required this.url,
      required this.receivedDate,
      this.orderId,
      this.servieId});
  final String serviceName, orderedBy;
  final int quantity;
  int? fromProcessed;
  final DateTime dueDate, receivedDate;
  final int? isCustomized;
  String? customDescription;
  final double totalPrice;
  final String url;
  final int? orderId, servieId;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xff662465), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.fromLTRB(0, 14, 0, 8),
      color: const Color(0xFFFFFDF0),
      elevation: 0,
      child: InkWell(
        onTap: () {
          // Navigator.push(
          // context,
          // MaterialPageRoute(builder: (ctx) => ServiceDetails(serviceId: serviceId))

          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  height: MediaQuery.of(context).size.width * 0.32,
                  width: MediaQuery.of(context).size.width * 0.26,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isCustomized == null
                            ? widget.serviceName
                            : '${widget.serviceName} (customized)',
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ordered by: ${widget.orderedBy}',
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'due:${widget.dueDate.toLocal()}'.split(' ')[0],
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Received:${widget.receivedDate.toLocal()}'
                            .split(' ')[0],
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Quantity: ${widget.quantity}',
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Price: ${widget.totalPrice}\$',
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                      widget.fromProcessed == null
                          ? Row(
                              children: [
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : TextButton(
                                        onPressed: () async {
                                          if (!mounted) return;
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          try {
                                            await Provider.of<Orders>(context,
                                                    listen: false)
                                                .acceptService(
                                                    widget.orderId!,
                                                    widget.servieId!,
                                                    widget.isCustomized);
                                            if (!mounted)
                                              return; // Check again after the async operation
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 76, 27, 75),
                                                content: Text(
                                                  'Accepted successfully',
                                                  style: TextStyle(
                                                    color: beige,
                                                  ),
                                                ),
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                          } finally {
                                            if (!mounted) return;
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Provider.of<Orders>(context,
                                                    listen: false)
                                                .fetchPendingOrders();
                                            Provider.of<Orders>(context,
                                                    listen: false)
                                                .fetchProcessedOrders();
                                          }
                                        },
                                        child: Text(
                                          'Accept',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 56, 134, 59),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                Spacer(),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          try {
                                            await Provider.of<Orders>(context,
                                                    listen: false)
                                                .rejectService(
                                                    widget.orderId!,
                                                    widget.servieId!,
                                                    widget.isCustomized);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 76, 27, 75),
                                                content: Text(
                                                  'Rejected successfully',
                                                  style: TextStyle(
                                                    color: beige,
                                                  ),
                                                ),
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                          } finally {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Reject',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 254, 162, 150),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                Spacer(),
                              ],
                            )
                          : Container(),
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
