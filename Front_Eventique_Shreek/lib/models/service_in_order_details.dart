class ServiceInOrderDetails {
  final int? serviceId;
  final int? orderId;
  final int quantity;
  final double totalPrice;
  final String imgUrl;
  final String status;
  final String name,orederdBy;
  final DateTime dueDate;
  final DateTime arrivDate;

  final int? isCustomized;
  final String? customDescription;

  ServiceInOrderDetails(
      {required this.status,
      required this.name,
      required this.orederdBy,
       this.serviceId,
       this.orderId,
      required this.quantity,
      required this.totalPrice,
      required this.imgUrl,
      required this.dueDate,
      required this.arrivDate,

      this.isCustomized,
      this.customDescription,
      });
}
