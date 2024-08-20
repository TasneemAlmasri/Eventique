import 'package:eventique/color.dart';
import 'package:eventique/providers/vendors_provider.dart';
import 'package:eventique/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = 'chat-list';

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchVendors();
  // }

  Future<void> _fetchVendors() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<VendorsProvider>(context, listen: false)
          .fetchAllVendors();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      print('Error fetching vendors: $error');
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _fetchVendors();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorsProvider = Provider.of<VendorsProvider>(context);
    final vendors = vendorsProvider.vendorsList;
    print(vendors);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontFamily: 'IrishGrover',
            fontSize: 26,
            color: primary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: primary,
            ))
          : vendors.isEmpty
              ? const Center(
                  child: Text(
                  'No vendors found.',
                  style: TextStyle(
                    fontFamily: 'CENSCBK',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primary,
                  ),
                ))
              : ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (ctx, i) {
                    final vendor = vendors[i];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ChatScreen.routeName,
                          arguments: {
                            'vendorId': vendor.id,
                            'vendorName': vendor.companyName,
                            'vendorImageUrl': vendor.imageUrl,
                          },
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 9,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: darkBackground,
                              backgroundImage: vendor.imageUrl != null &&
                                      vendor.imageUrl!.isNotEmpty
                                  ? NetworkImage(vendor.imageUrl!)
                                  : null,
                              child: vendor.imageUrl!.isNotEmpty
                                  ? null
                                  : Icon(
                                      Icons.person,
                                      size: 25,
                                      color: white,
                                    ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  vendor.companyName,
                                  style: TextStyle(
                                    fontFamily: 'CENSCBK',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: primary,
                                  ),
                                ),
                                Text(
                                  'Chat with ${vendor.companyName}',
                                  style: TextStyle(
                                    fontFamily: 'CENSCBK',
                                    fontSize: 14,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
