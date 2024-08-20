//taghreed
import 'package:eventique/color.dart';
import 'package:eventique/providers/share_event_provider.dart';
import 'package:eventique/widgets/pickers/multiple_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareEventScreen extends StatefulWidget {
  static const routeName = '/share-event';

  const ShareEventScreen({super.key});

  @override
  _ShareEventScreenState createState() => _ShareEventScreenState();
}

class _ShareEventScreenState extends State<ShareEventScreen> {
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _imageUrls = [];

  void _onImagesUploaded(List<String> imageUrls) {
    setState(() {
      _imageUrls = imageUrls;
    });
  }

  Future<void> _shareEvent() async {
    if (_imageUrls.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        
         SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content:const Text('Please upload at least three images'),
          ),
      );
      return;
    }
    final id = ModalRoute.of(context)!.settings.arguments as int;
    final description = _descriptionController.text;
    try {
      setState(() {
        _isLoading = true;
      });
      print(id);
      await Provider.of<ShareEventProvider>(context, listen: false)
          .shareEvent(id, description, _imageUrls);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
    // Send the data to your backend (this is just a placeholder).

    print('Sending to backend: $id,\n $description,\n $_imageUrls');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        shape: const Border(
          bottom: BorderSide(
            color: primary,
            width: 1.6,
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Share Event',
            style: TextStyle(
              color: primary,
              fontSize: 24,
              fontFamily: 'IrishGrover',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            const Text(
              'Thank you for letting us be a part of',
              style: TextStyle(
                color: primary,
                fontFamily: 'IrishGrover',
                fontSize: 18,
              ),
            ),
            const Text(
              'your wonderful moments',
              style: TextStyle(
                color: primary,
                fontFamily: 'IrishGrover',
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            MultiImagePicker(onImagesUploaded: _onImagesUploaded),
            SizedBox(
              height: size.height * 0.04,
            ),
            const Text(
              'Tell us about your event in one word!',
              style: TextStyle(
                color: primary,
                fontFamily: 'IrishGrover',
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  focusColor: secondary,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: darkBackground),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: secondary),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                maxLength: 20,
                maxLines: 1,
                cursorColor: secondary,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _shareEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary.withOpacity(0.8),
                      fixedSize: Size(size.width * 0.4, size.height * 0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: 'IrishGrover',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
