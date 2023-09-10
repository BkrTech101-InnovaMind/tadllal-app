// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  String? id;
  Attributes? attributes;

  Location({
    this.id,
    this.attributes,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
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

  Attributes({
    this.name,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
