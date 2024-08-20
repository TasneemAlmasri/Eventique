import 'package:flutter/material.dart';

class CustomizedScreen extends StatelessWidget {
  const CustomizedScreen(
      {super.key, required this.name, required this.customDescription});
  final String name, customDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Details",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontFamily: 'IrishGrover'),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
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
        body: Column(
          children: [
            const Text(
              'name: ',
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Bahnschrift',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff662465)),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                name,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Bahnschrift',
                    fontWeight: FontWeight.bold,
                    color: Color(0xff662465)),
              ),
            ),
            Text(customDescription),
          ],
        ));
  }
}
