// To parse this JSON data, do
//
//     final services = servicesFromJson(jsonString);

import 'dart:convert';

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  String? id;
  Attributes? attributes;

  Services({
    this.id,
    this.attributes,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
    id: json["id"],
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class Attributes {
  String? name;
  String? description;
  String? image;

  Attributes({
    this.name,
    this.description,
    this.image,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    name: json["name"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "image": image,
  };
}
