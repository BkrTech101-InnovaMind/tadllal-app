import 'package:tedllal/model/real_estate.dart';

class Notifications {
  String id;
  String status;
  RealEstate realEstate;

  Notifications({
    required this.id,
    required this.status,
    required this.realEstate,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      status: json['status'],
      realEstate: RealEstate.fromJson(json['realEstate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'realEstate': realEstate.toJson(),
    };
  }
}
