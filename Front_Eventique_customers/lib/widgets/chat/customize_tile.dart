import 'package:eventique/color.dart';
import 'package:eventique/widgets/choose_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventique/providers/carts.dart';

class CustomizeTile extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String serviceImage;
  final String serviceDes;
  final String price;
  final String userName;
  final String userImage;
  final bool isMe;
  final Key key;

  const CustomizeTile(
      {required this.serviceImage,
      required this.serviceId,
      required this.serviceName,
      required this.serviceDes,
      required this.price,
      required this.userName,
      required this.userImage,
      required this.isMe,
      required this.key});

  @override
  State<CustomizeTile> createState() => _CustomizeTileState();
}

class _CustomizeTileState extends State<CustomizeTile> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Carts>(context);
    ScaffoldMessengerState? _scaffoldMessengerState;

    // @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _scaffoldMessengerState?.hideCurrentSnackBar();
    super.dispose();
  }

    
    return Row(
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!widget.isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.userImage,
            ),
          ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: !widget.isMe ? Radius.circular(0) : Radius.circular(10),
              bottomRight: widget.isMe ? Radius.circular(0) : Radius.circular(10),
            ),
            color: white,
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                'Original service',
                style: TextStyle(
                  color: secondary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.serviceName,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Original service',
                style: TextStyle(
                  color: secondary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.serviceName,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.price,
                    style: TextStyle(
                      color: primary,
                      fontFamily: 'CENSCBK',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      cartProvider.chosenEventId==-1?
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor: beige,
                            backgroundColor: beige,
                            content: ChooseEvent(
                              imgUrl: widget.serviceImage,
                              name: widget.serviceName,
                              price: double.parse(widget.price) ,
                              serviceId:int.parse(widget.serviceId),
                              isCustom: true,
                              customDescription: widget.serviceDes,
                            ),
                            
                          );
                        },
                      ):

                       {   // Add service to cart
                              Provider.of<Carts>(context, listen: false)
                                  .addServiceToCart(
                                      int.parse(widget.serviceId) ,
                                      double.parse(widget.price),
                                      widget.userImage,
                                      widget.serviceName,
                                      true,
                                      widget.serviceDes
                                      ),

                                           // Show snack bar
                              _scaffoldMessengerState?.showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 76, 27, 75),
                                  content: Text(
                                    'Added successfully',
                                    style: TextStyle(
                                      color: beige,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              )
                    };
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(87, 14, 87, 1),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.36, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Add to cart',
                      style: const TextStyle(
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 253, 240, 1),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
