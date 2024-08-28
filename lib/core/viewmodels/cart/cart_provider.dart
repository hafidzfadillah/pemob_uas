import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pemob_uas/core/data/api_service.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/models/cart_model.dart';
import 'package:pemob_uas/core/models/product_model.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiResult<List<CartModel>> _cartResult = ApiResult.initial();
  ApiResult<List<CartModel>> get cartResult => _cartResult;

  ApiResult<String> _crudResult = ApiResult.initial();
  ApiResult<String> get crudResult => _crudResult;

  List<CartModel> _listSelected = [];
  List<CartModel> get listSelected => _listSelected;

  static CartProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  double get totalPrice {
    double total = 0.0;

    for (var item in _listSelected) {
      total += (double.tryParse(item.price) ?? 0.0) * item.quantity;
    }

    return total;
  }

  Future<void> fetchCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cartResult = ApiResult.loading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);

    try {
      var result = await _apiService.getCart(user.id);
      var list = result
          .map(
            (e) => CartModel.fromJson(e),
          )
          .toList();
      _cartResult = ApiResult.success(list);
    } catch (e) {
      print(e);
      _cartResult = ApiResult.error(e.toString());
    }

    notifyListeners();
  }

  Future<ApiResult> addToCart(ProductModel product, int qty) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);

    var param = {
      'product_id': product.productId,
      "user_id": user.id,
      "product_name": product.productName,
      "quantity": qty,
      "price": product.productPrice
    };

    try {
      final result = await _apiService.addToCart(param);

      _crudResult = ApiResult.success(result['message']);
    } catch (e) {
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
    return _crudResult;
  }

  Future<ApiResult> removeCart(String id) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);

    var param = {
      'product_id': id,
      "user_id": user.id,
    };

    try {
      final result = await _apiService.removeCartItem(param);

      _crudResult = ApiResult.success(result['message']);
    } catch (e) {
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
    return _crudResult;
  }

  Future<ApiResult> createOrder(lat,lng) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);

    var data = {
      'user_id': user.id,
      'items': json.encode(_listSelected),
      'total': totalPrice,
      'lat':lat,
      'lng':lng
    };

    try {
      final result = await _apiService.createOrder(data);
      _crudResult = ApiResult.success(result['message']);
    } catch (e) {
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
    return _crudResult;
  }

  bool selectItem(CartModel item) {
    _listSelected.add(item);
    notifyListeners();
    return true;
  }

  void deselectItem(String id) {
    _listSelected.removeWhere((element) => element.productId == id);
    notifyListeners();
  }

  void clearSelected() {
    _listSelected.clear();
    notifyListeners();
  }
}
