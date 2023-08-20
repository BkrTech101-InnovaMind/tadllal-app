import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/model/api_molels/user_preference.dart';
import 'package:tadllal/model/real_estate_type.dart';
import 'package:tadllal/services/api/dio_api.dart';
import 'package:tadllal/widgets/LodingUi/Loder2.dart';
import 'package:tadllal/widgets/save_dialog.dart';

import '../../config/global.dart';

class ChangeUserPreferencesPage extends StatefulWidget {
  const ChangeUserPreferencesPage({super.key});

  @override
  State<ChangeUserPreferencesPage> createState() =>
      _ChangeUserPreferencesPageState();
}

class _ChangeUserPreferencesPageState extends State<ChangeUserPreferencesPage> {
  late Future<List<RealEstateType>> realEstateTypeList;
  final DioApi dioApi = DioApi();
  List<RealEstateType> realEstateType = [];

  @override
  void initState() {
    setState(() {
      realEstateTypeList = _getData();
    });
    super.initState();
  }

  Future<List<RealEstateType>> _getTypeData() async {
    var typesRowData = await dioApi.get("/types");
    String typesJsonString = json.encode(typesRowData.data["data"]);
    List<Map<String, dynamic>> typesData = (jsonDecode(typesJsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    List<RealEstateType> typeList = (typesData)
        .map((itemWord) => RealEstateType.fromJson(itemWord))
        .toList();

    return typeList;
  }

  Future<List<UserPreference>> _getPreferencesData() async {
    var preferencesRowData = await dioApi.get("/preferences/show");

    String preferencesJsonString =
        json.encode(preferencesRowData.data["user_preferences"]);
    List<Map<String, dynamic>> preferencesData =
        (jsonDecode(preferencesJsonString) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
    List<UserPreference> preferencesList = (preferencesData)
        .map((itemWord) => UserPreference.fromJson(itemWord))
        .toList();

    return preferencesList;
  }

  Future<List<RealEstateType>> _getData() async {
    List<RealEstateType> dataList = [];

    List<RealEstateType> typeList = await _getTypeData();
    List<UserPreference> preferencesList = await _getPreferencesData();
    for (var type in typeList) {
      RealEstateType temp = type;
      print(temp.toJson());
      for (var preferences in preferencesList) {
        if (preferences.id == type.id) {
          temp.isChecked = true;
        }
      }
      dataList.add(temp);
    }

    return typeList;
  }

  void handleSubmit() {
    List<String> selectedPreferences = [];

    for (var element in realEstateType) {
      if (element.isChecked!) {
        selectedPreferences.add(element.id!);
      }
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SaveDialog(
        formValue: [
          {
            "path": "/preferences/add",
            "myData": {"types": selectedPreferences}
          }
        ],
        onUrlChanged: (data) {
          Navigator.of(context2).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تغيير المفضلة"),
            ),
          );

          Navigator.pop(context);

          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير المفضلة'),
        backgroundColor: const Color(0xFF194706),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTypesGrid(),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Types Grid Builder widget
  Widget buildTypesGrid() {
    return FutureBuilder<List<RealEstateType>>(
      future: realEstateTypeList,
      builder:
          (BuildContext context, AsyncSnapshot<List<RealEstateType>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.hasError == false) {
            realEstateType = snapshot.data!;
            return Expanded(
              child: DynamicHeightGridView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                itemCount: realEstateType.length,
                builder: (context, index) {
                  bool isChecked = realEstateType[index].isChecked!;
                  return Card(
                    color: isChecked ? const Color(0xFF1F4C6B) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          realEstateType[index].isChecked =
                              !realEstateType[index].isChecked!;
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SizedBox.fromSize(
                                    child: CachedNetworkImage(
                                      imageUrl: realEstateType[index]
                                          .attributes!
                                          .image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 15,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: isChecked ? null : Colors.white,
                                    gradient: isChecked
                                        ? LinearGradient(
                                            colors: [
                                              const Color(0xFF1F4C6B)
                                                  .withAlpha(200),
                                              const Color(0xFF8BC83F)
                                            ],
                                          )
                                        : null,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.check,
                                      color: isChecked
                                          ? Colors.white
                                          : Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            realEstateType[index].attributes!.name!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isChecked
                                  ? Colors.white
                                  : const Color(0xFF252B5C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(NO_DATA),
            ));
          } else {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(NO_DATA),
            ));
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ColorLoader2(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(LOADING_DATA_FROM_SERVER),
                )
              ],
            ),
          );
        } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(LOADING_DATA_FROM_SERVER),
                )
              ],
            ),
          );
        }
      },
    );
  }

  // Profile Editor Submit Button widget
  Widget buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      color: Colors.transparent,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF1F4C6B),
          fixedSize: const Size(278, 63),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
        ),
        onPressed: () {
          showDialog(context: context, builder: (_) => buildDialog());
        },
        child: const Text(
          "تعديل",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  buildDialog() {
    return AlertDialog(
      content: const Text(
        "هل متأكد من تغيير المفضلة ؟",
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("لا"),
        ),
        TextButton(
          onPressed: () {
            handleSubmit();
          },
          child: const Text("تأكيد"),
        ),
      ],
    );
  }
}
