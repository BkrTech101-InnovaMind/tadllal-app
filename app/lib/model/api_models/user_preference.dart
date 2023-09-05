// To parse this JSON data, do
//
//     final userPreference = userPreferenceFromJson(jsonString);

import 'dart:convert';

UserPreference userPreferenceFromJson(String str) => UserPreference.fromJson(json.decode(str));

String userPreferenceToJson(UserPreference data) => json.encode(data.toJson());

class UserPreference {
  String? id;
  String? name;
  String? image;
  bool? isChecked;

  UserPreference({
    this.id,
    this.name,
    this.image,
    this.isChecked,
  });

  factory UserPreference.fromJson(Map<String, dynamic> json) => UserPreference(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isChecked: json["isChecked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "isChecked": isChecked,
  };
}
