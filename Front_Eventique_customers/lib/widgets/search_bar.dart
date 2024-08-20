import 'package:eventique/providers/services_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySearchBar extends StatefulWidget {
  MySearchBar({super.key, this.enabled = true});
  bool enabled;

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed of
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chosenCategory = Provider.of<AllServices>(context).chosenCategory;
    var mediaq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 20, 30),
      child: TextField(
        enabled: widget.enabled,
        style: Theme.of(context).textTheme.bodyMedium,
        controller: _controller,
        onChanged: (text) {
          print(text);
        },
        decoration: InputDecoration(
          constraints:
              BoxConstraints(maxWidth: mediaq.width * 0.87, maxHeight: 52),
          hintText: 'Search in $chosenCategory',
          hintStyle: const TextStyle(
            fontFamily: 'IrishGrover',
            color: Color.fromARGB(255, 227, 181, 193),
          ),
          prefixIconColor: const Color.fromARGB(255, 226, 147, 168),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 8),
            child: Icon(Icons.search, size: 26),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 226, 147, 168)),
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
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:mashroo_1/providers/services_list.dart';
// import 'package:provider/provider.dart';

// class AutoCompleteSearchBar extends StatelessWidget {
//   AutoCompleteSearchBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _options = Provider.of<AllServices>(context).categorizedServices;
//     var mediaq = MediaQuery.of(context).size;
//     return Autocomplete<String>(
//       optionsBuilder: (TextEditingValue textEditingValue) {
//         if (textEditingValue.text == '') {
//           return const Iterable<String>.empty();
//         }
//         return _options.where((String option) {
//           return option
//               .toLowerCase()
//               .contains(textEditingValue.text.toLowerCase());
//         });
//       },
//       optionsViewBuilder: (BuildContext context,
//           AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
//         return Align(
//           alignment: Alignment.topCenter,
//           child: Material(
//             elevation: 4.0,
//             child: SizedBox(
//               width: mediaq.width * 0.87,
//               height: 100,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: options.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final String option = options.elementAt(index);
//                   return GestureDetector(
//                     onTap: () {
//                       onSelected(option);
//                     },
//                     child: ListTile(
//                       title: Text(option),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//       fieldViewBuilder: (BuildContext context,
//           TextEditingController fieldTextEditingController,
//           FocusNode fieldFocusNode,
//           VoidCallback onFieldSubmitted) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(18, 20, 20, 30),
//           child: TextField(
//             focusNode: fieldFocusNode,
//             controller: fieldTextEditingController,
//             decoration: InputDecoration(
//               constraints:
//                   BoxConstraints(maxWidth: mediaq.width * 0.87, maxHeight: 52),
//               hintText: 'Search...',
//               hintStyle: const TextStyle(
//                 fontFamily: 'IrishGrover',
//                 color: Color.fromARGB(255, 227, 181, 193),
//               ),
//               prefixIconColor: const Color.fromARGB(255, 226, 147, 168),
//               prefixIcon: const Padding(
//                   padding: EdgeInsets.only(left: 20.0, right: 8),
//                   child: Icon(Icons.search, size: 26)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide:
//                     const BorderSide(color: Color.fromARGB(255, 226, 147, 168)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: const BorderSide(color: Color(0xff662465)),
//               ),
//               filled: false,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
