// //tasneem
// enum Status {
//   pending,
//   accepted,
//   rejected,
// }

// class ServiceInOrderDetails {
//   final int orderServiceId;
//   final int quantity;
//   final double totalPrice;
//   final String imgUrl;
//   final Status status;
//   final String name;

//   ServiceInOrderDetails(
//       {required this.status,
//       required this.name,
//       required this.orderServiceId,
//       required this.quantity,
//       required this.totalPrice,
//       required this.imgUrl});
// }

class ServiceInOrderDetails {
  final int? orderServiceId;
  final int quantity;
  final double totalPrice;
  final String imgUrl;
  final String status;
  final String name;
   bool? isCustom;
   String? customDescription;

  ServiceInOrderDetails(
      {
      required this.status,
      required this.name,
      this.orderServiceId,
      required this.quantity,
      required this.totalPrice,
      required this.imgUrl,
      this.isCustom,
      this.customDescription,
      });
}
