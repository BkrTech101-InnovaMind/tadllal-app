import 'package:tedllal/model/api_models/user.dart';

class Data {
  User? user;
  String? token;
  String? code = "";

  Data({
    this.user,
    this.token,
    this.code,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"] ?? "",
        code: json["code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "code": code,
      };
}
