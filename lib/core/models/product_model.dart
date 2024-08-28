import 'dart:convert';

class ProductModel {
    final String productId;
    final String productName;
    final String productDesc;
    final String productPrice;
    final String productStock;
    final String isPublish;

    ProductModel({
        required this.productId,
        required this.productName,
        required this.productDesc,
        required this.productPrice,
        required this.productStock,
        required this.isPublish,
    });

    factory ProductModel.fromRawJson(String str) => ProductModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["product_id"],
        productName: json["product_name"],
        productDesc: json["product_desc"],
        productPrice: json["product_price"],
        productStock: json["product_stock"],
        isPublish: json["is_publish"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_desc": productDesc,
        "product_price": productPrice,
        "product_stock": productStock,
        "is_publish": isPublish,
    };
}
