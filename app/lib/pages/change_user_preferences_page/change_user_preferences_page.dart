import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/api_models/user_preference.dart';
import 'package:tedllal/model/real_estate_type.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';
import 'package:tedllal/widgets/pages_back_button.dart';
import 'package:tedllal/widgets/save_dialog.dart';

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

  void _onPressed() {
    showDialog(context: context, builder: (_) => buildDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F4F8),
                border: Border(bottom: BorderSide(color: Colors.black38)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PagesBackButton(),
                  MaterialButton(
                    height: 30.0,
                    minWidth: 50.0,
                    color: const Color(0xFFF5F4F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    textColor: const Color(0xFF1F4C6B),
                    padding: const EdgeInsets.all(16),
                    onPressed: _onPressed,
                    splashColor: const Color(0xFFF5F4F8),
                    child: const Text(
                      'تعديل',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            buildTypesGrid(),
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
              child: Container(
                margin: const EdgeInsets.only(top: 20),
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
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(noData),
            ));
          } else {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(noData),
            ));
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Column(
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
                    child: Text(loadingDataFromServer),
                  )
                ],
              ),
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
                  child: Text(loadingDataFromServer),
                )
              ],
            ),
          );
        }
      },
    );
  }

  buildDialog() {
    return AlertDialog(
      content: const Text(
        "هل متأكد من تغيير المفضلة ؟",
        textAlign: TextAlign.center,
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
          onPressed: () => Navigator.of(context).pop(),
          splashColor: Colors.redAccent,
          child: const Text(
            'إلغاء',
            style: TextStyle(fontSize: 12),
          ),
        ),
        MaterialButton(
          height: 30.0,
          minWidth: 50.0,
          color: Colors.lightGreenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          textColor: Colors.white,
          onPressed: handleSubmit,
          splashColor: Colors.lightGreenAccent,
          child: const Text(
            'تأكيد',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
