import 'package:flutter/material.dart';
import 'package:pemob_uas/core/models/user_model.dart';
import 'package:pemob_uas/ui/auth/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String IS_LOGIN = "IS_LOGIN";
  static const String USER_DATA = "USER_DATA";
  static const String FIREBASE_ID = "FIREBASE_ID";

  static void createLoginSession(UserModel user) async {
    final pref = await SharedPreferences.getInstance();

    var userToString = user.toRawJson();
    pref.setString(USER_DATA, userToString);
    pref.setBool(IS_LOGIN, true);
  }

  static Future<bool> checkIfLoggedin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(IS_LOGIN) ?? false;
  }

  static void handleLogout(context) async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();

    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => SignIn()), (route) => false);
  }

  static String dataToString(UserModel user) {
    return user.toRawJson();
  }

  static UserModel decodeUser(String user) {
    return UserModel.fromRawJson(user);
  }
}
