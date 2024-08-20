//tasneem
import 'package:eventique/models/service_in_order_details.dart';

class OneOrder {
  final String? orderId;
  final double? orderPrice;
  final double? orderPaidPrice;
  final List<ServiceInOrderDetails>? orderServices;
  final DateTime? dateTime;
  final String? eventName;
  OneOrder({
    this.orderServices,
    this.orderId,
    this.orderPrice,
    this.orderPaidPrice,
    this.dateTime,
    this.eventName,
  });
}
