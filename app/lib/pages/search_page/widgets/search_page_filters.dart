import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/model/real_estate_type.dart';
import 'package:tedllal/services/api/dio_api.dart';

Future<List<RealEstateType>> _getTypeData() async {
  var rowData = await DioApi().get("/types");
  String jsonString = json.encode(rowData.data["data"]);
  List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
      .map((e) => e as Map<String, dynamic>)
      .toList();
  return (data).map((itemWord) => RealEstateType.fromJson(itemWord)).toList();
}

Future<List<RealEstate>> _getRealEstateData() async {
  var rowData = await DioApi().get("/realEstate/realty");
  String jsonString = json.encode(rowData.data["data"]);
  List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
      .map((e) => e as Map<String, dynamic>)
      .toList();
  return (data)
      .map((itemWord) => RealEstate.fromJson(itemWord))
      .toSet()
      .toList();
}

class SearchPageFilters extends StatefulWidget {
  const SearchPageFilters(
      {super.key,
      required this.onSelectedSecondType,
      required this.onSelectedBaptism,
      required this.onSelectedFirstType,
      required this.onSelectedVision});
  final Function(String selectedSecondType) onSelectedSecondType;
  final Function(String selectedBaptism) onSelectedBaptism;
  final Function(String selectedFirstType) onSelectedFirstType;
  final Function(String selectedVision) onSelectedVision;

  @override
  State<SearchPageFilters> createState() => _SearchPageFiltersState();
}

class _SearchPageFiltersState extends State<SearchPageFilters> {
  String selectedSecondType = '';
  String selectedBaptism = '';
  String selectedFirstType = '';
  String selectedVision = '';

  List<String> secondTypes = ["for sale", "for rent"];
  List<RealEstate> baptisms = [];
  List<RealEstateType> firstTypes = [];
  List<RealEstate> visions = [];

  Future<void> _fetchFiltersData() async {
    baptisms = await _getRealEstateData();
    firstTypes = await _getTypeData();
    visions = await _getRealEstateData();
  }

  @override
  void initState() {
    _fetchFiltersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('الحالة'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: secondTypes.map((type) {
                          String typeTranslated = type;
                          type == "for rent"
                              ? typeTranslated = "للإيجار"
                              : typeTranslated = "للبيع";
                          return ListTile(
                            title: Text(typeTranslated),
                            onTap: () {
                              setState(() {
                                selectedSecondType = typeTranslated;
                              });
                              widget.onSelectedSecondType(type);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedSecondType = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'الحالة',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedSecondType),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('التصنيف'),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListView(
                          shrinkWrap: true,
                          children: firstTypes.map((type) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(type.attributes!.name!),
                                  onTap: () {
                                    setState(() {
                                      selectedFirstType =
                                          type.attributes!.name!;
                                    });
                                    widget.onSelectedFirstType(
                                        type.attributes!.name!);
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider()
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedFirstType = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'التصنيف',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedFirstType),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('التعميد'),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListView(
                          children: baptisms.map((baptism) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(baptism.attributes!.baptism!),
                                  onTap: () {
                                    setState(() {
                                      selectedBaptism =
                                          baptism.attributes!.baptism!;
                                    });
                                    widget.onSelectedBaptism(
                                        baptism.attributes!.baptism!);
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider()
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedBaptism = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'التعميد',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedBaptism),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('البصيرة'),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListView(
                          children: visions.map((vision) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(vision.attributes!.vision!),
                                  onTap: () {
                                    setState(() {
                                      selectedVision =
                                          vision.attributes!.vision!;
                                    });
                                    widget.onSelectedVision(
                                        vision.attributes!.vision!);
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider()
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedVision = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'البصيرة',
                // suffixIcon: Icon(Icons.arrow_drop_down),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedVision),
            ),
          ),
        ),
      ],
    );
  }
}
