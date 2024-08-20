import 'package:eventique_admin_dashboard/color.dart';
import 'package:eventique_admin_dashboard/widgets/vendor_tile.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description(
      {super.key, required this.description, required this.vendorName,required this.price});
  final String description, vendorName;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VendorTile(vendorname: vendorName),
          Row(
            children: [
              Text(
                'Price',
                style:
                    TextStyle(color: const Color.fromARGB(255, 226, 147, 168)),
              ),
              const SizedBox(
                width: 8,
              ),
              Text('$price', style: TextStyle(color: primary)),
            ],
          ),
          Text(
            'Description',
            style: TextStyle(color: const Color.fromARGB(255, 226, 147, 168)),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(description, style: TextStyle(color: primary)),
        ],
      ),
    );
  }
}
