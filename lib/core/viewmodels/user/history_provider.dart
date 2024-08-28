import 'package:flutter/material.dart';
import 'package:pemob_uas/core/data/api_service.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/models/order_model.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  ApiResult<List<OrderModel>> _orderResult = ApiResult.initial();
  ApiResult<List<OrderModel>> get orderResult => _orderResult;
  ApiResult<String> _crudResult = ApiResult.initial();
  ApiResult<String> get crudResult => _crudResult;

  static HistoryProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  Future<void> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _orderResult = ApiResult.loading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);

    bool isAdmin = user.isAdmin == 1;

    try {
      List<dynamic> result = [];

      if (isAdmin) {
        result = await _apiService.getAllOrders();
      } else {
        result = await _apiService.getOrders(user.id);
      }

      List<OrderModel> list =
          result.map((e) => OrderModel.fromJson(e)).toList();
      _orderResult = ApiResult.success(list);
    } catch (e) {
      print(e);
      _orderResult = ApiResult.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> updateStatus(OrderModel data) async {
    _crudResult = ApiResult.loading();
    notifyListeners();

    var status = "Delivery";
    if (data.orderStatus == "Delivery") {
      status = "Done";
    }

    try {
      final response = await _apiService.updateStatus(data.orderId, status);

      _crudResult = ApiResult.success(response['message']);
    } catch (e) {
      print(e);
      _crudResult = ApiResult.error(e.toString());
    }

    notifyListeners();
  }
}
