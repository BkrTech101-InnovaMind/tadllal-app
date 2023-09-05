import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/services.dart';
import 'package:tedllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/LodingUi/Loder2.dart';

class MostRequestedServicesPage extends StatefulWidget {
  const MostRequestedServicesPage({super.key});

  @override
  State<MostRequestedServicesPage> createState() =>
      _MostRequestedServicesPageState();
}

class _MostRequestedServicesPageState extends State<MostRequestedServicesPage> {
  final DioApi dioApi = DioApi();
  Future<List<Services>> subServicesDataList = Future(() => []);

  @override
  void initState() {
    _syncData();
    super.initState();
  }

  _syncData() {
    setState(() {
      subServicesDataList = _getSubServicesData();
    });
  }

  Future<List<Services>> _getSubServicesData() async {
    var rowData = await dioApi.get("/services/sub-services");
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
        title: const Text("ألخدمات الاكثر طلباً"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: FutureBuilder<List<Services>>(
            future: subServicesDataList,
            builder: (BuildContext context,
                AsyncSnapshot<List<Services>> subServices) {
              if (subServices.connectionState == ConnectionState.done) {
                if (subServices.hasData && subServices.hasError == false) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: subServices.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleSubServicesPage(
                                  subServiceDetails: subServices.data![index],
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  subServices.data![index].attributes!.image!)),
                          title:
                              Text(subServices.data![index].attributes!.name!),
                          subtitle: Text(
                            subServices.data![index].attributes!.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  );
                } else if (subServices.hasError) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(ERROR_WHILE_GET_DATA),
                  ));
                } else {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(NO_DATA),
                  ));
                }
              } else if (subServices.connectionState ==
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
            }),
      ),
    );
  }
}
