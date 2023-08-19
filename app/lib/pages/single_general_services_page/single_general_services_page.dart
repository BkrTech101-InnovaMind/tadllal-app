import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/model/services.dart';
import 'package:tadllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tadllal/services/api/dio_api.dart';
import 'package:tadllal/widgets/LodingUi/Loder2.dart';

class SingleGeneralServicesPage extends StatefulWidget {
  final Services servicesDetails;
  const SingleGeneralServicesPage({required this.servicesDetails, super.key});

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
    var rowData =
        await dioApi.get("/services/sub-services/${widget.servicesDetails.id}");
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
      appBar: AppBar(
        title: Text(widget.servicesDetails.attributes!.name!),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              widget.servicesDetails.attributes!.description!,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Services>>(
                future: subServicesDataList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Services>> snapshot) {
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
                              title:
                                  Text(snapshot.data![index].attributes!.name!),
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
                        child: Text(ERROR_WHILE_GET_DATA),
                      ));
                    } else {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(NO_DATA),
                      ));
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
          ],
        ),
      ),
    );
  }
}
