import 'package:eventique_admin_dashboard/color.dart';
import 'package:flutter/material.dart';

class VendorTile extends StatelessWidget {
  const VendorTile({super.key, required this.vendorname});
  final String vendorname;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 30, 24),
      child: Row(
        children: [
         const Card(
                shape: CircleBorder(
                  side: BorderSide(
                    color: primary,
                    width: 1,
                  ),
                ),
                elevation: 6,
                color: Colors.white,
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
                  style: TextStyle(color: Color.fromARGB(255, 226, 147, 168))),
              Text(
                vendorname,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: primary,fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
