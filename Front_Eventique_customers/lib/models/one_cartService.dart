//tasneem
class OneCartService {
  final int OneCartServiceId;
  final int quantity;
  final double totalPrice;
  final String imgUrl, name;
  bool? isCustom;
  String? customDescription;



  OneCartService({
    required this.OneCartServiceId,
    required this.quantity,
    required this.totalPrice,
    required this.imgUrl,
    required this.name,
    this.isCustom,
    this.customDescription,
  });
}
