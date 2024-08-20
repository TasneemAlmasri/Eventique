import '/color.dart';
import 'package:eventique/screens/vendors_screen.dart';
import 'package:eventique/providers/carts.dart';
import 'package:eventique/providers/orders.dart';
import 'package:eventique/widgets/cart_tile.dart';
import 'package:eventique/widgets/my_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestCart extends StatefulWidget {
  const TestCart({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventBudget,
  });
  final String eventName;
  final int eventId;
  final double eventBudget;

  @override
  State<TestCart> createState() => _TestCartState();
}

class _TestCartState extends State<TestCart> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle? bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;
    final cartProvider = Provider.of<Carts>(context);
    final orderTotalPrice = cartProvider.getOrderTotalPrice(widget.eventId);
    double availableBudget = widget.eventBudget - orderTotalPrice >= 0
        ? widget.eventBudget - orderTotalPrice
        : 0;
    double exceededBudget = widget.eventBudget - orderTotalPrice >= 0
        ? 0
        : -(widget.eventBudget - orderTotalPrice);

    final cart = cartProvider.getCart(widget.eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventName,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: 'IrishGrover'),
        ),
      ),
      body: Container(
        child: cart.isEmpty
            ? Stack(
                children: [
                  Center(
                    child: Text(
                      'Cart Is Empty',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: 'IrishGrover',
                            fontSize: 22,
                            color: const Color.fromARGB(255, 227, 181, 193),
                          ),
                    ),
                  ),
                  // Positioned circle button
                  Positioned(
                    bottom: 68,
                    right: 32,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const VendorsScreen())));
                        cartProvider.chosenEventId = widget.eventId;
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      tooltip: 'Add Service',
                      child: const Icon(
                        Icons.add,
                        color: beige,
                      ),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Added services
                      Text(
                        'Added Services',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontFamily: 'IrishGrover'),
                      ),
                      // Container
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Stack(children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 400, // 500
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFFFFDF0),
                              boxShadow: [
                                // Top-left shadow
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  offset: const Offset(5, 5),
                                  blurRadius: 2,
                                  spreadRadius:
                                      -3, // Negative to simulate inner shadow
                                ),
                                // Bottom-right shadow
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  offset: const Offset(-5, -5),
                                  blurRadius: 2,
                                  spreadRadius:
                                      -3, // Negative to simulate inner shadow
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: cart.length,
                              itemBuilder: (ctx, i) => CartTile(
                                  services: cart,
                                  i: i,
                                  eventId: widget.eventId),
                            ),
                          ),
                          // Positioned circle button
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const VendorsScreen())));
                                cartProvider.chosenEventId = widget.eventId;
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                              tooltip: 'Add Service',
                              child: const Icon(
                                Icons.add,
                                color: beige,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      // Budget
                      Text(
                        'Budget',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontFamily: 'IrishGrover'),
                      ),
                      // Container
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFFFFDF0),
                            boxShadow: [
                              // Top-left shadow
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                offset: const Offset(5, 5),
                                blurRadius: 2,
                                spreadRadius:
                                    -3, // Negative to simulate inner shadow
                              ),
                              // Bottom-right shadow
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                offset: const Offset(-5, -5),
                                blurRadius: 2,
                                spreadRadius:
                                    -3, // Negative to simulate inner shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 2,
                                child: Text(
                                  'Current Total: $orderTotalPrice\$',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontFamily: 'IrishGrover',
                                          fontSize: 17,
                                          letterSpacing: 1),
                                ),
                              ),
                              const SizedBox(height: 18),
                              MyPieChart(
                                cart: cart,
                                totalPriceForOrder: orderTotalPrice,
                              ),
                              const SizedBox(height: 38),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 2,
                                child: Text(
                                  'Event Budget: ${widget.eventBudget}\$',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontFamily: 'IrishGrover',
                                          fontSize: 17,
                                          letterSpacing: 1),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Available ',
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: bodyMediumStyle,
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    flex: 2,
                                    child: Text(
                                      '$availableBudget\$',
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: bodyMediumStyle!.copyWith(
                                        color: const Color(0xffCCA0C7),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    flex: 2,
                                    child: Text(
                                      'Exceeded ',
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: bodyMediumStyle,
                                    ),
                                  ),
                                  Text(
                                    '$exceededBudget\$',
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: bodyMediumStyle.copyWith(
                                      color: const Color(0xffCCA0C7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      try {
                                        bool success =
                                            await Provider.of<Orders>(context,
                                                    listen: false)
                                                .addOrder(widget.eventId, cart);
                                        if (success) {
                                          Provider.of<Carts>(context,
                                                  listen: false)
                                              .clearCart(widget.eventId);
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
                                                'Ordered successfully',
                                                style: TextStyle(
                                                  color: beige,
                                                ),
                                              ),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                'You do not have enough money',
                                                style: TextStyle(
                                                  color: beige,
                                                ),
                                              ),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'Order failed. Please try again.',
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
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                              ),
                              child: const Text(
                                'Order',
                                style: TextStyle(
                                    fontFamily: 'IrishGrover',
                                    fontSize: 18,
                                    color: Color(0xFFFFFDF0)),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
