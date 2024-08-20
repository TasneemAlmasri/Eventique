import 'package:eventique_company_app/models/one_service.dart';
import 'package:eventique_company_app/providers/services_list.dart';
import 'package:eventique_company_app/widgets/search_tile.dart';

import '/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _controller = TextEditingController();
  List<OneService> _searchResults = [];
  bool _isLoading = false; // Add loading state

  void _onSearchChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true; // Set loading to true before fetching data
    });

    Provider.of<AllServices>(context, listen: false)
        .getSearchInAll(text.toLowerCase())
        .then((searchResults) {
      setState(() {
        _searchResults = searchResults;
        _isLoading = false; // Set loading to false after fetching data
      });
    }).catchError((error) {
      print("Error fetching search results: $error");
      setState(() {
        _searchResults = [];
        _isLoading = false; // Set loading to false on error
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: beige,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _controller,
            onChanged: (text) {
              _onSearchChanged(text);
            },
            decoration: InputDecoration(
              constraints: BoxConstraints(maxWidth: mediaq.width * 0.87, maxHeight: 45),
              hintText: 'Search...',
              hintStyle: const TextStyle(
                fontFamily: 'IrishGrover',
                color: Color.fromARGB(255, 227, 181, 193),
              ),
              prefixIconColor: const Color.fromARGB(255, 226, 147, 168),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 8),
                child: Icon(Icons.search, size: 26),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color.fromARGB(255, 226, 147, 168)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xff662465)),
              ),
              filled: false,
            ),
          ),
        ),
      ),
      body: _controller.text.isEmpty
          ? Container() // Blank page when text is empty
          : _isLoading
              ? Center(child: CircularProgressIndicator()) // Show loading indicator
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return SearchTile(
                      serviceName: _searchResults[index].name!,
                      serviceUrl: _searchResults[index].imgsUrl!.isNotEmpty
                          ? _searchResults[index].imgsUrl![0]
                          : '', // Update with appropriate image URL handling
                      serviceId: _searchResults[index].serviceId,
                      serviceCompany: _searchResults[index].vendorName??'',
                    );
                  },
                ),
    );
  }
}
