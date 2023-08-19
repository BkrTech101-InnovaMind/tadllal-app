import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  Attributes? attributes;

  User({
    this.id,
    this.attributes,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class Attributes {
  String? name;
  String? email;
  String? role;
  String? phone;
  String? avatar = "";

  Attributes({
    this.name,
    this.email,
    this.role,
    this.phone,
    this.avatar,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"] ?? "",
        avatar: json["avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "avatar": avatar,
      };
}
