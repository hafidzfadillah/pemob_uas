import 'dart:convert';

class UserModel {
    final int id;
    final String username;
    final String email;
    final String fcmToken;
    final int isAdmin;
    final String token;

    UserModel({
        required this.id,
        required this.username,
        required this.email,
        required this.fcmToken,
        required this.isAdmin,
        required this.token,
    });

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        fcmToken: json["fcm_token"],
        isAdmin: json["is_admin"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "fcm_token": fcmToken,
        "is_admin": isAdmin,
        "token": token,
    };
}
