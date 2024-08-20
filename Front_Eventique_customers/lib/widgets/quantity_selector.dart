import 'package:eventique/providers/carts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({super.key, required this.serviceId});
  final int serviceId;
  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  @override
  Widget build(BuildContext context) {
    final changeQuantity = Provider.of<Carts>(context);
    int quantity = changeQuantity.getQuantity(widget.serviceId);

    var primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 30, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Quantity',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color.fromARGB(255, 226, 147, 168))),
          SizedBox(width: 18),
          // Minus button
          InkWell(
            onTap: () {
              changeQuantity.decrementQuantity(widget.serviceId);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: quantity != 1
                        ? primaryColor
                        : primaryColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.remove,
                color: quantity != 1
                    ? primaryColor
                    : primaryColor.withOpacity(0.3),
                size: 16,
              ),
            ),
          ),
          // Quantity display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${quantity}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          // Plus button
          InkWell(
            onTap: () {
              changeQuantity.incrementQuantity(widget.serviceId);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                color: primaryColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
