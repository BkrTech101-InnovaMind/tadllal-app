import 'package:flutter/material.dart';
import 'package:tedllal/model/api_molels/location.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/model/real_estate_type.dart';

class AppProvider extends ChangeNotifier {
  List<RealEstate> realEstateList = [];
  List<RealEstate> filteredRealEstateList = [];
  Location? location = Location();
  RealEstateType? type = RealEstateType();

  void filterRealEstateListByType({required RealEstateType type}) {
    this.type = type;
    if (this.type!.id!.isEmpty || type.id == "0") {
      if (location!.id == null ||
          location!.id!.isEmpty ||
          location!.id == "0") {
        filteredRealEstateList = realEstateList;
      } else {
        filteredRealEstateList = realEstateList
            .where(
                (element) => element.attributes!.location!.id == location!.id)
            .toList();
      }
    } else {
      if (location!.id == null ||
          location!.id!.isEmpty ||
          location!.id == "0") {
        filteredRealEstateList = realEstateList
            .where((element) => element.attributes!.firstType!.id == type.id)
            .toList();
      } else {
        filteredRealEstateList = realEstateList
            .where((element) =>
                (element.attributes!.location!.id == location!.id &&
                    element.attributes!.firstType!.id == type.id))
            .toList();
      }
    }

    notifyListeners();
  }

  void filterRealEstateListByLocation({required Location location}) {
    this.location = location;
    if (this.location!.id!.isEmpty || this.location!.id == "0") {
      if (type!.id == null || type!.id!.isEmpty || type!.id == "0") {
        filteredRealEstateList = realEstateList;
      } else {
        filteredRealEstateList = realEstateList
            .where((element) => element.attributes!.firstType!.id == type!.id)
            .toList();
      }
    } else {
      if (type!.id == null || type!.id!.isEmpty || type!.id == "0") {
        filteredRealEstateList = realEstateList
            .where((element) => element.attributes!.location!.id == location.id)
            .toList();
      } else {
        filteredRealEstateList = realEstateList
            .where((element) =>
                (element.attributes!.location!.id == location.id &&
                    element.attributes!.firstType!.id == type!.id))
            .toList();
      }
    }

    notifyListeners();
  }

  void addRealEstateList({required List<RealEstate> listData}) {
    realEstateList.clear();
    filteredRealEstateList.clear();
    realEstateList.addAll(listData);
    filteredRealEstateList.addAll(realEstateList);
    location = Location();
    type = RealEstateType();
    notifyListeners();
  }

  void addFilteredRealEstateList({required List<RealEstate> listData}) {
    filteredRealEstateList.clear();

    filteredRealEstateList.addAll(listData);

    notifyListeners();
  }

  void ret() {
    filteredRealEstateList.clear();

    filteredRealEstateList.addAll(realEstateList);

    notifyListeners();
  }
}
