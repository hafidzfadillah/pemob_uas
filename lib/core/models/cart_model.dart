import 'dart:convert';

class CartModel {
  final String productId;
  final String productName;
  final int quantity;
  final String price;

  CartModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory CartModel.fromRawJson(String str) =>
      CartModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
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
