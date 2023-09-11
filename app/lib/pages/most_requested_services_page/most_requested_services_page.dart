import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/services.dart';
import 'package:tedllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';
import 'package:tedllal/widgets/pages_back_button.dart';

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
    var rowData = await dioApi.get("/NewServices/services/");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return (data).map((itemWord) => Services.fromJson(itemWord)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F4F8),
                  border: Border(bottom: BorderSide(color: Colors.black38)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Row(
                  children: [
                    const PagesBackButton(),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "خدماتنا الاكثر طلباً",
                          style:
                              TextStyle(fontSize: 18, color: Color(0xFF1F4C6B)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Services>>(
                    future: subServicesDataList,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Services>> subServices) {
                      if (subServices.connectionState == ConnectionState.done) {
                        if (subServices.hasData &&
                            subServices.hasError == false) {
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
                                        builder: (context) =>
                                            SingleSubServicesPage(
                                          subServiceDetails:
                                              subServices.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(subServices
                                          .data![index].attributes!.image!)),
                                  title: Text(subServices
                                      .data![index].attributes!.name!),
                                  subtitle: Text(
                                    subServices
                                        .data![index].attributes!.description!,
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
                            child: Text(errorWhileGetData),
                          ));
                        } else {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(noData),
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
            ],
          ),
        ),
      ),
    );
  }
}
