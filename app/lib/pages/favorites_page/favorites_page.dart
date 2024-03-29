import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/methods/in_intro_tour_preferences.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/pages/real_estate_details_page/real_estate_details_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/utils/in_intro_tour.dart';
import 'package:tedllal/widgets/error_dialog.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin<FavoritesPage> {
  final DioApi dioApi = DioApi();
  final realEstateKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  late Future<List<RealEstate>> realStateDataList;

  @override
  void initState() {
    setState(() {
      realStateDataList = _getRealEstateData();

      realStateDataList.then((value) {
        if (value.isNotEmpty) {
          tutorialCoachMark = TutorialCoachMark(
            targets: addFavoritesPageTarget(realEstateKey: realEstateKey),
            colorShadow: const Color(0xFF194706),
            paddingFocus: 10,
            hideSkip: false,
            opacityShadow: 0.8,
            showSkipInLastTarget: false,
            onFinish: () {
              SaveTourForFirstTime().saveTourForFirstTime();
            },
          );
          showTutorial();
        }
      });
    });

    super.initState();
  }

  @override
  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: RefreshIndicator(
          onRefresh: () async {
            refresh();
          },
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "مفضلاتي ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF234F68),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<RealEstate>>(
                  future: realStateDataList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<RealEstate>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.hasError == false) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              key: index == 0 ? realEstateKey : null,
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 10, right: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F4F8),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.2,
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'هل انت متأكد من الحذف ؟'),
                                            actions: [
                                              MaterialButton(
                                                height: 30.0,
                                                minWidth: 50.0,
                                                color: Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                splashColor: Colors.redAccent,
                                                child: const Text(
                                                  'إلغاء',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              MaterialButton(
                                                height: 30.0,
                                                minWidth: 50.0,
                                                color: const Color(0xFF8BC83F),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  dioApi
                                                      .delete(
                                                          "/favorites/remove/${snapshot.data![index].id}")
                                                      .catchError((e) {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                              context2) =>
                                                          const ErrorDialog(
                                                        desc:
                                                            "فشلت عملية الحذف من المفضلة",
                                                      ),
                                                    );

                                                    return e;
                                                  }).then((value) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      snapshot.data!
                                                          .removeAt(index);
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "تم الحذف بنجاح",
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                                splashColor:
                                                    const Color(0xFF8BC83F),
                                                child: const Text(
                                                  'تأكيد',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'حذف',
                                    )
                                  ],
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RealEstateDetailsPage(
                                          realEstate: snapshot.data![index]);
                                    }));
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(snapshot
                                        .data![index].attributes!.photo!),
                                  ),
                                  title: Text(
                                    snapshot.data![index].attributes!.name!,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${snapshot.data![index].attributes!.price!} \$',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        Text(snapshot.data![index].attributes!
                                            .ratings!.averageRating!),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFE0A410),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(errorWhileGetData),
                        ));
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(noData),
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
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
                              child: Text(loadingDataFromServer),
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
                              child: Text(loadingDataFromServer),
                            )
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void showTutorial() {
    Future.delayed(const Duration(seconds: 1), () {
      SaveTourForFirstTime().getTourForFirstTimeState().then(
        (value) {
          if (value == false) {
            if (mounted) {
              tutorialCoachMark.show(context: context);
            }
          }
        },
      );
    });
  }

  Future<List<RealEstate>> _getRealEstateData() async {
    var rowData = await dioApi.get("/favorites/show");
    String jsonString = json.encode(rowData.data["favorites"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    return (data).map((itemWord) => RealEstate.fromJson(itemWord)).toList();
  }

  _syncData() {
    setState(() {
      realStateDataList = _getRealEstateData();
    });
  }

  Future<void> refresh() async {
    _syncData();
  }

  // Slidable Children
  List<SlidableAction> slidableChildren = [
    SlidableAction(
      onPressed: (context) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('هل انت متأكد من الحذف ؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("لا"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "تم الحذف بنجاح",
                      ),
                    ),
                  );
                },
                child: const Text("نعم"),
              )
            ],
          ),
        );
      },
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'حذف',
    )
  ];
}
