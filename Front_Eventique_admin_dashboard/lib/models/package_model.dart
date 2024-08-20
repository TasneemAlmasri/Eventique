import 'package:eventique_admin_dashboard/models/one_service.dart';

class Package {
  int? id;
  String? name;
  double? oldPrice;
  double? newPrice;
  String? imageUrl;
  List<OneService>? packageServices;
  Package({
    this.id,
    this.name,
    this.oldPrice,
    this.newPrice,
    this.imageUrl,
    this.packageServices,
  });
}
