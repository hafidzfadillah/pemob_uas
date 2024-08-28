import 'dart:convert';

class OrderModel {
  final String orderId;
  final List<Item> items;
  final String totalAmount;
  final DateTime orderDate;
  final String orderLat;
  final String orderLon;
  final String orderStatus;
  final String? userId;
  final String? userName;

  OrderModel(
      {required this.orderId,
      required this.items,
      required this.totalAmount,
      required this.orderDate,
      required this.orderLat,
      required this.orderLon,
      required this.orderStatus,
      this.userId,
      this.userName});

  factory OrderModel.fromRawJson(String str) =>
      OrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderModel.fromJson(Map<String, dynamic> jsonn) => OrderModel(
        orderId: jsonn["order_id"].toString(),
        items: List<Item>.from(
            json.decode(jsonn["items"]).map((x) => Item.fromJson(x))),
        totalAmount: jsonn["total_amount"].toString(),
        orderDate: DateTime.parse(jsonn["order_date"]),
        orderLat: jsonn["order_lat"].toString(),
        orderLon: jsonn["order_lon"].toString(),
        orderStatus: jsonn["order_status"],
        userId: jsonn["user_id"] ?? '0',
        userName: jsonn["user_name"] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "total_amount": totalAmount,
        "order_date": orderDate.toIso8601String(),
        "order_lat": orderLat,
        "order_lon": orderLon,
        "order_status": orderStatus,
        "user_id": userId,
      };
}

class Item {
  final String productId;
  final String productName;
  final int quantity;
  final String price;

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["product_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "price": price,
      };
}
