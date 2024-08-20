import '/color.dart';
import '/models/service_in_order_details.dart';
import '/providers/orders.dart';
import '/widgets/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final orderProvider = Provider.of<Orders>(context, listen: false);
      await Future.wait([
        orderProvider.fetchPendingOrders(),
        orderProvider.fetchProcessedOrders(),
      ]);
    } catch (error) {
      // Handle any errors here
      print('Error fetching orders: $error');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: beige,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primary, // Set color if needed
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: const Color(0xFFFFFDF0),
                    surfaceTintColor: const Color(0xFFFFFDF0),
                    elevation: 0,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        decoration: BoxDecoration(
                          color: const Color(0xffEFEEEA),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          dividerColor: const Color(0xffEFEEEA),
                          labelColor: primary,
                          unselectedLabelColor: const Color(0xffE791A5),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFFFFFDF0),
                          ),
                          tabs: const [
                            Tab(
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                    fontFamily: 'IrishGrover', fontSize: 20),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Processed',
                                style: TextStyle(
                                    fontFamily: 'IrishGrover', fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      children: [
                        buildOrderList(
                            orderProvider.pendingOrders, context, null),
                        buildOrderList(
                            orderProvider.proccecdOrders, context, 1),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildOrderList(List<ServiceInOrderDetails> orders,
      BuildContext context, int? fromProcessed) {
    return orders.isEmpty
        ? Center(
            child: Text(
              'No Orders Yet',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontFamily: 'IrishGrover',
                    fontSize: 22,
                    color: const Color.fromARGB(255, 227, 181, 193),
                  ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 40),
            itemCount: orders.length,
            itemBuilder: (ctx, i) {
              return OrderTile(
                fromProcessed: fromProcessed,
                dueDate: orders[i].dueDate,
                isCustomized: orders[i].isCustomized,
                customDescription: orders[i].customDescription,
                orderedBy: orders[i].orederdBy,
                quantity: orders[i].quantity,
                serviceName: orders[i].name,
                totalPrice: orders[i].totalPrice,
                url: orders[i].imgUrl,
                receivedDate: orders[i].arrivDate,
                orderId:orders[i].orderId ,
                servieId: orders[i].serviceId,
              );
            },
          );
  }
}
