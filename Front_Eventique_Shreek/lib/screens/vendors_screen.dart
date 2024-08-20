import '/color.dart';
import '/screens/create_service.dart';
import '/widgets/search_bar.dart';
import '/widgets/services_grid.dart';
import 'package:flutter/material.dart';
import 'search_results_screen.dart'; // Import the new search results screen

class VendorsScreen extends StatelessWidget {
  const VendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: beige,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchResultsScreen()),
                      );
                    },
                    child: MySearchBar(
                      enabled: false,
                    ),
                  ),
                  Text(
                    'My Services',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'IrishGrover',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff662465)),
                  ),
                  ServicesGrid(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 32,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => CreateService())));
            },
            child: Icon(
              Icons.add,
              color: beige,
            ),
            backgroundColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            tooltip: 'Add Service',
          ),
        ),
      ],
    );
  }
}
