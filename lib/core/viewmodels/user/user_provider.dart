import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_service.dart';
import '../../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isDisposed = false;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // User data
  UserModel? _user;
  UserModel? get user => _user;

  static UserProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  Future<void> login(email, password) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var fId = pref.getString(SessionManager.FIREBASE_ID) ?? '';

      if (fId.isEmpty) {
        fId = await FirebaseMessaging.instance.getToken() ?? '';
      }

      final result = await _apiService.login(email, password, fId);

      _isAuthenticated = true;
      _user = UserModel.fromJson(result['user']);

      SessionManager.createLoginSession(_user!);
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      rethrow;
    }

    notifyListeners();
  }

  Future<String> register(name, email, password) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var fId = pref.getString(SessionManager.FIREBASE_ID) ?? '';

      if (fId.isEmpty) {
        fId = await FirebaseMessaging.instance.getToken() ?? '';
      }

      print("fId:$fId");

      final response = await _apiService.register(name, email, password, fId);
      return response['message'];
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> checkAuthStatus() async {
    final pref = await SharedPreferences.getInstance();
    _isAuthenticated = pref.getBool(SessionManager.IS_LOGIN) ?? false;

    if (_isAuthenticated) {
      _user =
          SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);
    }
    notifyListeners();
  }
}
