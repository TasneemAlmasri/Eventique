import 'package:eventique/models/one_order.dart';
import 'package:eventique/screens/order_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order, required this.index});
  final OneOrder order;
  final int index;

  @override
  Widget build(BuildContext context) {
    // Themes
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xff662465), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      color: const Color(0xFFFFFDF0),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => OrderDetails(
                id: order.orderId!,
                eventName: order.eventName!,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Order Number and Event Name
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ${index}',
                      style: bodyMediumStyle!
                          .copyWith(fontFamily: 'IrishGrover', fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      // 'Event: ${order.eventName}',
                      order.eventName!,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyMediumStyle.copyWith(
                          // color: Color(0xffDD8CA1),
                          fontFamily: 'IrishGrover',
                          fontWeight: FontWeight.normal,
                          color: Color(0xffDD8CA1),
                          fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Total Price and Date
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${order.orderPrice!.toStringAsFixed(2)} \$',
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyMediumStyle.copyWith(
                        // color: Color(0xffDD8CA1),
                        fontFamily: 'IrishGrover',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${order.dateTime!.toLocal()}'.split(' ')[0],
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Format the date
                      style: bodyMediumStyle.copyWith(
                        color: Color.fromARGB(255, 174, 165, 168),
                        fontFamily: 'IrishGrover',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
