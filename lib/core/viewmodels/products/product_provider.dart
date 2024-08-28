import 'package:flutter/material.dart';
import 'package:pemob_uas/core/data/api_service.dart';
import 'package:pemob_uas/core/models/product_model.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/api/api_result.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiResult<List<ProductModel>> _productsResult = ApiResult.initial();
  ApiResult<List<ProductModel>> get productsResult => _productsResult;

  ApiResult<String> _crudResult = ApiResult.initial();
  ApiResult<String> get crudResult => _crudResult;

  static ProductProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  Future<void> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _productsResult = ApiResult.loading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    var isAdmin = pref.getBool(SessionManager.IS_LOGIN) ?? false;

    try {
      var result = await _apiService.getProducts(isAdmin);
      var list = result
          .map(
            (e) => ProductModel.fromJson(e),
          )
          .toList();
      _productsResult = ApiResult.success(list);
    } catch (e) {
      _productsResult = ApiResult.error(e.toString());
    }

    notifyListeners();
  }

  Future<ApiResult> createProduct(ProductModel data) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    try {
      final result = await _apiService.createProduct(data);
      _crudResult = ApiResult.success(result['message']);
    } catch (e) {
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
    return _crudResult;
  }

  Future<ApiResult> updateProduct(ProductModel data) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    try {
      final result = await _apiService.updateProduct(data);
      _crudResult = ApiResult.success(result['message']);
    } catch (e) {
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
    return _crudResult;
  }

  Future<ApiResult> deleteProduct(String id) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    try {
      final result = await _apiService.deleteProduct(id);
      _crudResult = ApiResult.success(result['message']);
    } catch (e) {
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
    return _crudResult;
  }
}
