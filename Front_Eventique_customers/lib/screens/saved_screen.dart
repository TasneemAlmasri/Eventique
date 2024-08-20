import 'package:eventique/models/one_service.dart';
import 'package:eventique/providers/saved.dart';
import 'package:eventique/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedServices extends StatefulWidget {
  const SavedServices({super.key});

  @override
  _SavedServicesState createState() => _SavedServicesState();
}

class _SavedServicesState extends State<SavedServices> {
  bool _isLoading = true;
  bool _hasFetchedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data only if it hasn't been fetched before
    if (!_hasFetchedData) {
      _fetchSavedServices();
    }
  }

  Future<void> _fetchSavedServices() async {
    try {
      await Provider.of<Saved>(context, listen: false).fetchSaved();
    } catch (error) {
      // Handle errors if needed
      print("Error fetching saved services: $error");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasFetchedData = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedProvider = Provider.of<Saved>(context);
    final List<OneService> displayedServices = savedProvider.savedServices;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Saved Services",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontFamily: 'IrishGrover'),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Container(
              height: 4.0,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Services",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: 'IrishGrover'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: (displayedServices.isNotEmpty)
          ? GridView.builder(
              key: ValueKey<int>(displayedServices.length), // Unique key for AnimatedSwitcher
              padding: const EdgeInsets.all(26),
              itemCount: displayedServices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (ctx, i) => ServiceItem(
                imgurl: (displayedServices[i].imgsUrl != null ||
                        displayedServices[i].imgsUrl!.isNotEmpty)
                    ? displayedServices[i].imgsUrl![0]
                    : 'ops',
                name: displayedServices[i].name,
                rating: displayedServices[i].rating,
                vendorName: displayedServices[i].vendorName,
                serviceId: displayedServices[i].serviceId,
                fromSaved: true,
              ),
              shrinkWrap: true,
            )
          : Center(
              child: Text(
                'Nothing Saved Yet',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontFamily: 'IrishGrover',
                      fontSize: 22,
                      color: const Color.fromARGB(255, 227, 181, 193),
                    ),
              ),
            ),
    );
  }
}
