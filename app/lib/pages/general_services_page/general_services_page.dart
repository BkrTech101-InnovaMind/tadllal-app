import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/services.dart';
import 'package:tedllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';

class GeneralServicesPage extends StatefulWidget {
  const GeneralServicesPage({super.key});

  @override
  State<GeneralServicesPage> createState() => _GeneralServicesPageState();
}

class _GeneralServicesPageState extends State<GeneralServicesPage> {
  final DioApi dioApi = DioApi();
  Future<List<Services>> servicesDataList = Future(() => []);

  @override
  void initState() {
    _syncData();
    super.initState();
  }

  _syncData() {
    setState(() {
      servicesDataList = _getServicesData();
    });
  }

  Future<List<Services>> _getServicesData() async {
    var rowData = await dioApi.get("/services");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return (data).map((itemWord) => Services.fromJson(itemWord)).toList();
  }

  Future<List<Services>> _getSubServicesData({required String id}) async {
    var rowData = await dioApi.get("/services/sub-services/$id");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return (data).map((itemWord) => Services.fromJson(itemWord)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("كل الخدمات الإنشائية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: FutureBuilder<List<Services>>(
            future: servicesDataList,
            builder: (BuildContext context,
                AsyncSnapshot<List<Services>> generalServices) {
              if (generalServices.connectionState == ConnectionState.done) {
                if (generalServices.hasData &&
                    generalServices.hasError == false) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: generalServices.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              generalServices.data![index].attributes!.image!,
                            ),
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.srcATop,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TapToExpand(
                          openedHeight: 200,
                          closedHeight: 68,
                          scrollable: true,
                          scrollPhysics: const BouncingScrollPhysics(),
                          onTapPadding: 0,
                          color: Colors.transparent,
                          boxShadow: const [
                            BoxShadow(color: Colors.transparent)
                          ],
                          duration: const Duration(seconds: 1),
                          content: Column(
                            children: [
                              Text(
                                  generalServices
                                      .data![index].attributes!.description!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Card(
                                elevation: 0,
                                color: Colors.white.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SizedBox(
                                  height: 89,
                                  child: FutureBuilder<List<Services>>(
                                      future: _getSubServicesData(
                                          id: generalServices.data![index].id!),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<Services>>
                                              subServices) {
                                        if (subServices.connectionState ==
                                            ConnectionState.done) {
                                          if (subServices.hasData &&
                                              subServices.hasError == false) {
                                            return ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  subServices.data!.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15),
                                                  child: Column(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SingleSubServicesPage(
                                                                subServiceDetails:
                                                                    subServices
                                                                            .data![
                                                                        index],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        style: TextButton.styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            shape:
                                                                const CircleBorder()),
                                                        child: CircleAvatar(
                                                          radius: 28,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  subServices
                                                                      .data![
                                                                          index]
                                                                      .attributes!
                                                                      .image!),
                                                        ),
                                                      ),
                                                      Text(
                                                          subServices
                                                              .data![index]
                                                              .attributes!
                                                              .name!,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (subServices.hasError) {
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
                                            ));
                                          }
                                        } else if (subServices
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: ColorLoader2(),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 16),
                                                  child: Text(
                                                      loadingDataFromServer),
                                                )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 16),
                                                  child: Text(
                                                      loadingDataFromServer),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            generalServices.data![index].attributes!.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.1,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (generalServices.hasError) {
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
                  ));
                }
              } else if (generalServices.connectionState ==
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
      ),
    );
  }
}
