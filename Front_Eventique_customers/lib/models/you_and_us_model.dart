import 'package:eventique/models/one_service.dart';

class YouAndUs {
  int? id;
  String? description;
  List<String>? imagesUrl;
  List<OneService>? eventServices;
  YouAndUs({
    this.id,
    this.description,
    this.imagesUrl,
    this.eventServices,
  });
}
