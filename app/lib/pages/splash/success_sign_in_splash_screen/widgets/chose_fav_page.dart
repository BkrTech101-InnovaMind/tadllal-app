import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/model/real_estate_type.dart';
import 'package:tadllal/services/api/dio_api.dart';
import 'package:tadllal/widgets/LodingUi/Loder2.dart';

class ChoseFavPage extends StatefulWidget {
  const ChoseFavPage({super.key, required this.onTypePressed});
  final Function(RealEstateType type) onTypePressed;

  @override
  State<ChoseFavPage> createState() => _ChoseFavPageState();
}

class _ChoseFavPageState extends State<ChoseFavPage> {
  late Future<List<RealEstateType>> realEstateTypeList;
  final DioApi dioApi = DioApi();

  @override
  void initState() {
    setState(() {
      realEstateTypeList = _getTypeData();
    });
    super.initState();
  }

  Future<List<RealEstateType>> _getTypeData() async {
    var rowData = await dioApi.get("/types");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    return (data).map((itemWord) => RealEstateType.fromJson(itemWord)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        buildTexts(),
        buildTypesGrid(),
      ],
    );
  }

  // Text widget
  Widget buildTexts() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: Text.rich(
            TextSpan(
              text: "أختر أنواع ",
              style: TextStyle(fontSize: 25, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: "العقارات ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "التي تفضلها.")
              ],
            ),
          ),
        ),
        Text.rich(
          TextSpan(
            text: "يمكنك تعديل هذا لاحقاً في ",
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: "إعدادات التفضيلات",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
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
            return DynamicHeightGridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              itemCount: snapshot.data!.length,
              builder: (context, index) {
                bool isChecked = snapshot.data![index].isChecked!;
                return Card(
                  color: isChecked ? const Color(0xFF1F4C6B) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        snapshot.data![index].isChecked =
                            !snapshot.data![index].isChecked!;
                      });

                      widget.onTypePressed(snapshot.data![index]);
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
                            CachedNetworkImage(
                                errorWidget: (context, url, error) => SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SizedBox.fromSize(
                                          child: Image.asset(
                                              "assets/images/shape.png",
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                imageBuilder: (context, imageProvider) {
                                  return SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox.fromSize(
                                        child: Image(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                },
                                imageUrl:
                                    snapshot.data![index].attributes!.image!,
                                placeholder: (context, url) => Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/shape.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                            // Image.asset(realEstates[index]['image']),
                            Positioned(
                              top: 10,
                              left: 15,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
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
                                    color:
                                        isChecked ? Colors.white : Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data![index].attributes!.name!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isChecked
                                ? Colors.white
                                : const Color(0xFF252B5C),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
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
}
