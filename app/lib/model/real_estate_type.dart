// To parse this JSON data, do
//
//     final type = typeFromJson(jsonString);

import 'dart:convert';

RealEstateType typeFromJson(String str) => RealEstateType.fromJson(json.decode(str));

String typeToJson(RealEstateType data) => json.encode(data.toJson());

class RealEstateType {
  String? id;
  Attributes? attributes;
  bool? isChecked;

  RealEstateType({
    this.id,
    this.attributes,
    this.isChecked
  });

  factory RealEstateType.fromJson(Map<String, dynamic> json) => RealEstateType(
    id: json["id"],
      isChecked:json["isChecked"]??false,
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isChecked":isChecked??false,
    "attributes": attributes?.toJson(),
  };
}

class Attributes {
  String? name;
  String? image;

  Attributes({
    this.name,
    this.image,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
  };
}
