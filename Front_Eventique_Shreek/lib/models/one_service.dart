
class OneService {
  final int? serviceId;
  final String? name, vendorName;
  final double? price;
  final String? description;
  final bool? isDiscountedPackages;
  final bool? isActivated;
  final int? categoryId;
  final double? rating;
  final List<String>? imgsUrl;

  OneService(
      {this.serviceId,
      this.name,
      this.vendorName,
      this.price,
      this.description,
      this.isDiscountedPackages,
      this.isActivated,
      this.categoryId,
      this.rating,
      this.imgsUrl});
}
