//taghreed
import 'package:eventique/color.dart';
import 'package:eventique/models/vendor_model.dart';
import 'package:eventique/providers/vendors_provider.dart';
import 'package:eventique/screens/chat_screen.dart';
import 'package:eventique/widgets/categories_list.dart';
import 'package:eventique/widgets/vendors/vendor_profile_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class VendorProfileScreen extends StatelessWidget {
  static const routeName = '/vendor-profile';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vendorId = ModalRoute.of(context)!.settings.arguments as String;
    final vendorInfo = Provider.of<VendorsProvider>(context).findById(vendorId);
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            color: darkBackground,
            child:
                //
                // vendorInfo.coverImageUrl != null
                //     ? Image.network(vendorInfo.coverImageUrl!)
                //     :
                Icon(
              Icons.person,
              color: white,
              size: 75,
            ),
          ),
          Positioned(
            top: 160,
            left: 50,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  // backgroundImage: vendorInfo.imageUrl != null
                  //     ? NetworkImage(vendorInfo.imageUrl!)
                  //     : null,
                  child:
                      // vendorInfo.imageUrl != null
                      //     ? null
                      //     :
                      Icon(
                    Icons.person,
                    color: white,
                    size: 50,
                  ),
                ),
                SizedBox(
                  height: size.width * 0.02,
                ),
                Text(
                  vendorInfo.companyName,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'IrishGrover',
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: white,
              child: IconButton(
                highlightColor: darkBackground,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: {
                      'vendorId': vendorInfo.id,
                      'vendorName': vendorInfo.companyName,
                      'vendorImageUrl': vendorInfo.imageUrl,
                    },
                  );
                },
                icon: Icon(
                  Icons.chat_outlined,
                  color: secondary,
                  size: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.4,
              left: size.width * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VendorProfileItem(
                    title: 'About', subTitle: vendorInfo.description),
                VendorProfileItem(
                    title: 'Location', subTitle: vendorInfo.location),
                VendorProfileItem(
                  title: 'Working hours',
                  subTitle: vendorInfo.workHours.isNotEmpty
                      ? vendorInfo.workHours
                          .map((workHour) =>
                              '${workHour.day}: ${workHour.hoursFrom} - ${workHour.hoursTo}')
                          .join('\n')
                      : 'No working hours provided',
                ),
                VendorProfileItem(
                    title: 'phone', subTitle: vendorInfo.phoneNumber),
              ],
            ),
          )
        ],
      ),
    );
  }
}
