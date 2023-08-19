// To parse this JSON data, do
//
//     final realEstate = realEstateFromJson(jsonString);

import 'dart:convert';

RealEstate realEstateFromJson(String str) => RealEstate.fromJson(json.decode(str));

String realEstateToJson(RealEstate data) => json.encode(data.toJson());

class RealEstate {
  String? id;
  Attributes? attributes;

  RealEstate({
    this.id,
    this.attributes,
  });

  factory RealEstate.fromJson(Map<String, dynamic> json) => RealEstate(
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
  int? price;
  FirstType? location;
  String? locationInfo;
  FirstType? firstType;
  String? state;
  String? secondType;
  DateTime? date;
  String? photo;
  Ratings? ratings;
  bool? isFavorite;
  List<String>? images;

  Attributes({
    this.name,
    this.description,
    this.price,
    this.location,
    this.locationInfo,
    this.firstType,
    this.state,
    this.secondType,
    this.date,
    this.photo,
    this.ratings,
    this.isFavorite,
    this.images,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    name: json["name"],
    description: json["description"],
    price: json["price"],
    location: json["location"] == null ? null : FirstType.fromJson(json["location"]),
    locationInfo: json["locationInfo"],
    firstType: json["firstType"] == null ? null : FirstType.fromJson(json["firstType"]),
    state: json["state"],
    secondType: json["secondType"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    photo: json["photo"],
    ratings: json["ratings"] == null ? null : Ratings.fromJson(json["ratings"]),
    isFavorite: json["isFavorite"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "location": location?.toJson(),
    "locationInfo": locationInfo,
    "firstType": firstType?.toJson(),
    "state": state,
    "secondType": secondType,
    "date": date?.toIso8601String(),
    "photo": photo,
    "ratings": ratings?.toJson(),
    "isFavorite": isFavorite,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}

class FirstType {
  String? id;
  String? name;

  FirstType({
    this.id,
    this.name,
  });

  factory FirstType.fromJson(Map<String, dynamic> json) => FirstType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Ratings {
  int? ratingCount;
  String? averageRating;

  Ratings({
    this.ratingCount,
    this.averageRating,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
    ratingCount: json["rating_count"],
    averageRating: json["average_rating"],
  );

  Map<String, dynamic> toJson() => {
    "rating_count": ratingCount,
    "average_rating": averageRating,
  };
}
