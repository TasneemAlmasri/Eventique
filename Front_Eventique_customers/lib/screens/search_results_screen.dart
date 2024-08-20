import '/color.dart';
import 'package:eventique/models/one_service.dart';
import 'package:eventique/providers/services_list.dart';
import 'package:eventique/widgets/search_tile.dart';
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

  void _onSearchChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    Provider.of<AllServices>(context, listen: false)
        .getSearchInAll(text.toLowerCase())
        .then((searchResults) {
      setState(() {
        _searchResults = searchResults;
      });
    }).catchError((error) {
      print("Error fetching search results: $error");
      setState(() {
        _searchResults = [];
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
      appBar: AppBar(
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
              constraints:
                  BoxConstraints(maxWidth: mediaq.width * 0.87, maxHeight: 45),
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
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 226, 147, 168)),
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
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return SearchTile(
                  serviceName: _searchResults[index].name,
                  serviceUrl: _searchResults[index].imgsUrl.isNotEmpty
                      ? _searchResults[index].imgsUrl[0]
                      : '', // Update with appropriate image URL handling
                  serviceId: _searchResults[index].serviceId,
                  serviceCompany: _searchResults[index].vendorName,
                );
              },
            ),
    );
  }
}
