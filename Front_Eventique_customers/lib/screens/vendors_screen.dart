import 'package:eventique/providers/services_list.dart';
import 'package:eventique/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventique/widgets/categories_list.dart';
import 'package:eventique/widgets/services_grid.dart';
import 'search_results_screen.dart'; 

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final allServices = Provider.of<AllServices>(context, listen: false);
    try {
      await allServices.fetchCategories();
      await allServices.fetchAllServices();
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchResultsScreen(),
                          ),
                        );
                      },
                      child: MySearchBar(
                        enabled: false,
                      ),
                    ),
                    const CategoriesList(),
                    ServicesGrid(),
                  ],
                ),
              ),
      ),
    );
  }
}
