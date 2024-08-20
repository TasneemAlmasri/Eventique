import 'package:eventique/models/one_order.dart';
import 'package:eventique/widgets/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventique/providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch data only if it's not already being fetched
    if (_isLoading) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    final orderProvider = Provider.of<Orders>(context, listen: false);

    try {
      await Future.wait([
        orderProvider.fetchProcessedOrders(),
        orderProvider.fetchPendingOrders(),
      ]);
    } catch (error) {
      // Handle errors if needed
      print("Error fetching orders: $error");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context);
    final allOrders = orderProvider.orders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: const Color(0xFFFFFDF0),
                    // shadowColor: Color(0xFFFFFDF0),
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
                          labelColor: Theme.of(context).primaryColor,
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
                            orderProvider.pendingOrders, allOrders, context),
                        buildOrderList(
                            orderProvider.processedOrders, allOrders, context),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildOrderList(
      List<OneOrder> orders, List<OneOrder> allOrders, BuildContext context) {
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
          // reverse: true,
            padding: EdgeInsets.only(bottom: 40.0),
            itemCount: orders.length,
            itemBuilder: (ctx, i) {
              return OrderTile(
                order: orders[i],
                index: i + 1,
              );
            },
          );
  }
}
