class OneService {
  final int serviceId;
  final int categoryId;
  final String name;
  final double? rating; // Nullable
  final String vendorName;
  final List<String> imgsUrl;
  final double price;
  final String description;

  OneService({
    required this.serviceId,
    required this.categoryId,
    required this.name,
    required this.rating,
    required this.vendorName,
    required this.imgsUrl,
    required this.price,
    required this.description,
  });
}
