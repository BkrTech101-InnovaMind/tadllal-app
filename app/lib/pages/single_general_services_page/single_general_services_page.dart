import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/services.dart';
import 'package:tedllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';
import 'package:tedllal/widgets/pages_back_button.dart';

class SingleGeneralServicesPage extends StatefulWidget {
  final String serviceId;
  const SingleGeneralServicesPage({required this.serviceId, super.key});

  @override
  State<SingleGeneralServicesPage> createState() =>
      _SingleGeneralServicesPageState();
}

class _SingleGeneralServicesPageState extends State<SingleGeneralServicesPage> {
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
    var rowData = await dioApi.get("/NewServices/byType/${widget.serviceId}");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    return (data).map((itemWord) => Services.fromJson(itemWord)).toList();
  }

  Future<void> refresh() async {
    _syncData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBarRow(),
            buildSubServicesDataList(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBarRow() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F4F8),
        border: Border(bottom: BorderSide(color: Colors.black38)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Row(
        children: [
          const PagesBackButton(),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                widget.serviceId == "1"
                    ? "جميع الخدمات الإنشائية"
                    : "جميع الموارد",
                style: const TextStyle(fontSize: 18, color: Color(0xFF1F4C6B)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubServicesDataList() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Services>>(
          future: subServicesDataList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Services>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.hasError == false) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleSubServicesPage(
                                subServiceDetails: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        title: Text(snapshot.data![index].attributes!.name!),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data![index].attributes!.image!),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 2);
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
          },
        ),
      ),
    );
  }
}
