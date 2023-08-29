// To parse this JSON data, do
//
//     final realEstate = realEstateFromJson(jsonString);

import 'dart:convert';

RealEstate realEstateFromJson(String str) => RealEstate.fromJson(json.decode(str));

String realEstateToJson(RealEstate data) => json.encode(data.toJson());

class RealEstate {
  String? id;
  RealEstateAttributes? attributes;

  RealEstate({
    this.id,
    this.attributes,
  });

  factory RealEstate.fromJson(Map<String, dynamic> json) => RealEstate(
    id: json["id"],
    attributes: json["attributes"] == null ? null : RealEstateAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class RealEstateAttributes {
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
  List<Comment>? comments;

  RealEstateAttributes({
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
    this.comments,
  });

  factory RealEstateAttributes.fromJson(Map<String, dynamic> json) => RealEstateAttributes(
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
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
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
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  String? id;
  CommentAttributes? attributes;

  Comment({
    this.id,
    this.attributes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    attributes: json["attributes"] == null ? null : CommentAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class CommentAttributes {
  int? userId;
  String? userName;
  String? userImage;
  String? comment;

  CommentAttributes({
    this.userId,
    this.userName,
    this.userImage,
    this.comment,
  });

  factory CommentAttributes.fromJson(Map<String, dynamic> json) => CommentAttributes(
    userId: json["user_id"],
    userName: json["user_name"],
    userImage: json["user_image"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "user_image": userImage,
    "comment": comment,
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
