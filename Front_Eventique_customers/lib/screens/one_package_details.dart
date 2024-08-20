import 'package:eventique/providers/home_provider.dart';
import 'package:eventique/providers/orders.dart';
import 'package:eventique/screens/choose_event_package.dart';
import 'package:eventique/widgets/choose_event.dart';
import 'package:provider/provider.dart';
import '/color.dart';
import 'package:eventique/screens/my_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class OnePackageDetailsPage extends StatefulWidget {
  static const routeName = '/package';

  @override
  _OnePackageDetailsPageState createState() => _OnePackageDetailsPageState();
}

class _OnePackageDetailsPageState extends State<OnePackageDetailsPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final packageId = ModalRoute.of(context)!.settings.arguments as int;
    final packageData = Provider.of<HomeProvider>(context).findPackageById(packageId);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          packageData.name!,
          style: const TextStyle(
            color: primary,
            fontSize: 28,
            fontFamily: 'IrishGrover',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Divider(
            color: Colors.black,
            height: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Was ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primary,
                        fontSize: 20),
                  ),
                  TextSpan(
                      text: '\$${packageData.oldPrice}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 217, 54, 54))),
                  const TextSpan(
                      text: ' , now only',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primary,
                          fontSize: 20)),
                  TextSpan(
                      text: ' \$${packageData.newPrice}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 210, 179, 0))),
                  const TextSpan(
                      text: ' with this exclusive package deal!',
                      style: TextStyle(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: MyStaggeredGridView(
              packageId: packageId,
            ),
          ),
          ElevatedButton(
            onPressed: (){
               Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>  ChooseEventPackage(packageId: packageId)),));
            },
            //  _isLoading
            //     ? null
            //     : () async {
            //         setState(() {
            //           _isLoading = true;
            //         });
            //         try {
            //           bool success = await Provider.of<Orders>(context, listen: false).orderPackage(packageData.id!);
            //           if (success) {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                 behavior: SnackBarBehavior.floating,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                 ),
            //                 backgroundColor: const Color.fromARGB(255, 76, 27, 75),
            //                 content: Text(
            //                   'Ordered successfully',
            //                   style: TextStyle(
            //                     color: beige,
            //                   ),
            //                 ),
            //                 duration: const Duration(seconds: 1),
            //               ),
            //             );
            //           } else {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                 behavior: SnackBarBehavior.floating,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                 ),
            //                 backgroundColor: Colors.red,
            //                 content: Text(
            //                   'You do not have enough money',
            //                   style: TextStyle(
            //                     color: beige,
            //                   ),
            //                 ),
            //                 duration: const Duration(seconds: 1),
            //               ),
            //             );
            //           }
            //         } catch (error) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               behavior: SnackBarBehavior.floating,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10),
            //               ),
            //               backgroundColor: Colors.red,
            //               content: Text(
            //                 'Order failed. Please try again.',
            //                 style: TextStyle(
            //                   color: beige,
            //                 ),
            //               ),
            //               duration: const Duration(seconds: 1),
            //             ),
            //           );
            //         } finally {
            //           setState(() {
            //             _isLoading = false;
            //           });
            //         }
            //       },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
            ),
            child: _isLoading
                ? CircularProgressIndicator(
                    color: Color(0xFFFFFDF0),
                  )
                : const Text(
                    'Order Package',
                    style: TextStyle(
                        fontFamily: 'IrishGrover',
                        fontSize: 18,
                        color: Color(0xFFFFFDF0)),
                  ),
          ),
        ],
      ),
    );
  }
}
