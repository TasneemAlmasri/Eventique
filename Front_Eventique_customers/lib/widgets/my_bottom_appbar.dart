import '/color.dart';
import 'package:eventique/providers/carts.dart';
import 'package:eventique/providers/reviews.dart';
import 'package:eventique/providers/services_list.dart';
import 'package:eventique/widgets/choose_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({
    super.key,
    required this.price,
    required this.serviceId,
    required this.imgUrl,
    required this.name,
  });
  final double price;
  final int serviceId;
  final String imgUrl;
  final String name;

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  final TextEditingController _commentController = TextEditingController();
  ScaffoldMessengerState? _scaffoldMessengerState;

  // @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    // Hide any active Snackbar when the widget is disposed
    _scaffoldMessengerState?.hideCurrentSnackBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primarycolor = Theme.of(context).primaryColor;
    TextTheme texttheme = Theme.of(context).textTheme;

    final reviewProvider = Provider.of<Reviews>(context);
    final int selectedIndex =Provider.of<AllServices>(context).indexForBotomContent;
    final cartProvider = Provider.of<Carts>(context);
     final quantity = cartProvider.getQuantity(widget.serviceId);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        shadowColor: Theme.of(context).primaryColor,
        elevation: 30,
        surfaceTintColor: const Color(0xFFFFFDF0),
        color: const Color(0xFFFFFDF0),
        padding: EdgeInsets.symmetric(horizontal: selectedIndex == 0 ? 26 : 8),
        child: selectedIndex == 0
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      '\$${widget.price * quantity}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 20, fontFamily: 'IrishGrover'),
                    ),
                  ),
                  const Spacer(),
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
                              imgUrl: widget.imgUrl,
                              name: widget.name,
                              price: widget.price,
                              serviceId: widget.serviceId,
                            ),
                            
                          );
                        },
                      ):

                       {   // Add service to cart
                              Provider.of<Carts>(context, listen: false)
                                  .addServiceToCart(
                                      widget.serviceId,
                                      widget.price,
                                      widget.imgUrl,
                                      widget.name,
                                      null,null),

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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Add To Cart',
                      style: TextStyle(
                          fontFamily: 'IrishGrover',
                          fontSize: 18,
                          color: Color(0xFFFFFDF0)),
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      controller: _commentController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _commentController.clear();
                            setState(() {});
                          },
                          icon: Icon(
                            _commentController.text.isNotEmpty
                                ? Icons.clear
                                : null,
                            color: primarycolor,
                            size: 20,
                          ),
                        ),
                        hintText: 'Share a review....',
                        hintStyle: texttheme.bodyMedium!.copyWith(
                            fontSize: 16, color: primarycolor.withOpacity(0.4)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: primarycolor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: primarycolor),
                        ),
                      ),
                      style: texttheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: primarycolor,
                    ),
                    onPressed: () {
                      if (_commentController.text.trim().isNotEmpty) {
                        reviewProvider.addReview(
                          widget.serviceId,
                          _commentController.text,
                          'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',//not needed
                          'me',//not needed
                        );
                        _commentController.clear();
                        // Close the keyboard
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
