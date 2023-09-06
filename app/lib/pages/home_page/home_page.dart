import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/methods/api_provider.dart';
import 'package:tedllal/model/api_models/location.dart';
import 'package:tedllal/model/api_models/user.dart';
import 'package:tedllal/model/filter_option.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/model/real_estate_type.dart';
import 'package:tedllal/model/services.dart';
import 'package:tedllal/pages/home_page/widgets/locations_filter.dart';
import 'package:tedllal/pages/home_page/widgets/menu_filter.dart';
import 'package:tedllal/pages/home_page/widgets/real_estates_card.dart';
import 'package:tedllal/pages/home_page/widgets/type_filter.dart';
import 'package:tedllal/pages/most_requested_services_page/most_requested_services_page.dart';
import 'package:tedllal/pages/notification_page/notification_page.dart';
import 'package:tedllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/services/helpers.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();
    path.lineTo(0, h);
    path.quadraticBezierTo(w / 1.55, h, w / 1.65, 0);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;
  final DioApi dioApi = DioApi();
  final Map<String, dynamic> allLocationAndType = {
    "id": "0",
    "attributes": {"name": "الكل"}
  };

  Future<List<Services>> servicesDataList = Future(() => []);
  Future<List<Services>> subServicesDataList = Future(() => []);
  Future<List<Location>> locationDataList = Future(() => []);
  Future<List<RealEstateType>> typeDataList = Future(() => []);

  @override
  void initState() {
    if (kDebugMode) {
      print("Token ${Config().token}");
      if (Config().token.isEmpty) {}
      User u = Config().user;
      print("User ${u.toJson()}");
    }
    _syncData();
    super.initState();
  }

  Future<void> refresh() async {
    _syncData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: HalfCircleClipper(),
              child: Container(
                height: 200,
                color: const Color(0xFFE3E3E3),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.only(bottom: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        MenuFilter(
                          onFiltersChecked:
                              (List<FilterOption> selectedOptions) {
                            List<RealEstate> data =
                                Provider.of<AppProvider>(context, listen: false)
                                    .realEstateList;
                            if (selectedOptions.isEmpty) {
                              setState(() {
                                Provider.of<AppProvider>(context, listen: false)
                                    .ret();
                              });
                            }
                            for (var element in selectedOptions) {
                              switch (element.label) {
                                case "للإيجار":
                                  {
                                    if (element.isChecked == true) {
                                      List<RealEstate> temp = data
                                          .where((element2) =>
                                              element2.attributes!.secondType ==
                                              "for rent")
                                          .toList();
                                      setState(() {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .addFilteredRealEstateList(
                                                listData: temp);
                                      });
                                    }
                                    break;
                                  }
                                case "للبيع":
                                  {
                                    if (element.isChecked == true) {
                                      List<RealEstate> temp = data
                                          .where((element2) =>
                                              element2.attributes!.secondType ==
                                              "for sale")
                                          .toList();
                                      setState(() {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .addFilteredRealEstateList(
                                                listData: temp);
                                      });
                                    }
                                    break;
                                  }
                                case "التقييم":
                                  {
                                    if (element.isChecked == true) {
                                      List<RealEstate> temp = data;
                                      temp.sort((a, b) => a
                                          .attributes!.ratings!.averageRating!
                                          .compareTo(b.attributes!.ratings!
                                              .averageRating!));
                                      setState(() {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .addFilteredRealEstateList(
                                                listData: temp);
                                      });
                                    }
                                    break;
                                  }
                                default:
                                  {
                                    setState(
                                      () {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .ret;
                                      },
                                    );
                                  }
                              }
                            }
                          },
                        ),
                        Row(
                          children: [
                            buildNotificationsIcon(true),
                            const SizedBox(
                              width: 5,
                            ),
                            buildUserImage(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          buildService(),
                          buildMostRequest(),
                          FutureBuilder<List<Location>>(
                              future: locationDataList,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Location>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData &&
                                      snapshot.hasError == false) {
                                    return LocationFilter(
                                      locationList: snapshot.data!,
                                      onLocationPressed: (Location location) {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .filterRealEstateListByLocation(
                                                location: location);
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
                                } else if (snapshot.connectionState ==
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
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(loadingDataFromServer),
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
                          FutureBuilder<List<RealEstateType>>(
                              future: typeDataList,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<RealEstateType>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData &&
                                      snapshot.hasError == false) {
                                    return TypeFilter(
                                      typeList: snapshot.data!,
                                      onTypePressed: (RealEstateType type) {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .filterRealEstateListByType(
                                                type: type);
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
                                } else if (snapshot.connectionState ==
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
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(loadingDataFromServer),
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
                          const SizedBox(height: 20),
                          const RealEstateCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _syncData() {
    _setRealEstateData();
    setState(() {
      servicesDataList = _getServicesData();
      locationDataList = _getLocationData();
      typeDataList = _getTypeData();
      subServicesDataList = _getSubServicesData();
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

  Future<List<Services>> _getSubServicesData() async {
    var rowData = await dioApi.get("/services/sub-services");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return (data).map((itemWord) => Services.fromJson(itemWord)).toList();
  }

  Future<void> _setRealEstateData() async {
    var rowData = await dioApi.get("/realEstate/filters/by-Preference");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    List<RealEstate> realEstate =
        (data).map((itemWord) => RealEstate.fromJson(itemWord)).toList();
    providerListener().addRealEstateList(listData: realEstate);
  }

  AppProvider providerListener() =>
      Provider.of<AppProvider>(context, listen: false);
  Future<List<Location>> _getLocationData() async {
    var rowData = await dioApi.get("/locations");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    List<Location> locationList =
        (data).map((itemWord) => Location.fromJson(itemWord)).toList();
    locationList.insert(0, Location.fromJson(allLocationAndType));
    return locationList;
  }

  Future<List<RealEstateType>> _getTypeData() async {
    var rowData = await dioApi.get("/types");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    List<RealEstateType> typeList =
        (data).map((itemWord) => RealEstateType.fromJson(itemWord)).toList();
    typeList.insert(0, RealEstateType.fromJson(allLocationAndType));
    return typeList;
  }

// User image widget
  Widget buildUserImage() {
    String userImage = Config().user.attributes!.avatar ?? "";

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: (userImage.isNotEmpty)
          ? CachedNetworkImage(
              imageBuilder: (context, imageProvider) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFDFDFDF), width: 2),
                  ),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              imageUrl: userImage,
              placeholder: (context, url) {
                return Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFDFDFDF), width: 2),
                    ),
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/avatar_placeholder.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ));
              },
              errorWidget: (context, url, error) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFDFDFDF), width: 2),
                  ),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/avatar_placeholder.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            )
          : userPlaceHolderImage(),
    );
  }

// Notifications icon widget
  Widget buildNotificationsIcon(bool hasNotification) {
    return Container(
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: TextButton(
        style: TextButton.styleFrom(
            shape: const CircleBorder(), padding: const EdgeInsets.all(4)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationPage(
                isHasNotification: hasNotification,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8bc83f), width: 2),
              ),
              child: const Icon(
                Icons.notifications_none_sharp,
                size: 28,
              ),
            ),
            Visibility(
              visible: hasNotification,
              child: Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFD5F4A),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // service Widget
  Widget buildService() {
    final serviceData = [
      {
        'image': 'assets/images/services.png',
        'title': 'خدمات إنشائية \n وصيانة',
        'subtitle': 'خدمات تصميم وتنفيذ',
      },
      {
        'image': 'assets/images/resources.png',
        'title': 'موارد بناء وتوريدات',
        'subtitle': 'أطلب أي مواد تحتاجها لبناء \n حلمك',
      },
    ];
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "خدمات إنشائية وتوريدات",
                style: TextStyle(
                    color: Color(0xFF234F68), fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: MediaQuery.of(context).size.width / 2,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: serviceData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.srcATop,
                          ),
                          child: Image.asset(
                            serviceData[index]['image'] ?? "",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceData[index]['title'] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  serviceData[index]['subtitle'] ?? "",
                                  style: const TextStyle(
                                      color: Colors.white, height: 1),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 23,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                              ),
                              color: Color(0xFF234F68),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // * Uncomment this widget and comment the previous one to change the services
  // * from the api instead of hard coding
  // Widget buildService() {
  //   var size = MediaQuery.of(context).size;
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 10),
  //     child: Column(
  //       children: [
  //         Container(
  //           margin: const EdgeInsets.all(10),
  //           child: const Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "خدمات إنشائية وتوريدات",
  //                 style: TextStyle(
  //                     color: Color(0xFF234F68), fontWeight: FontWeight.w900),
  //               ),
  //               // TextButton(
  //               //   onPressed: () {
  //               //     Navigator.push(
  //               //       context,
  //               //       MaterialPageRoute(
  //               //           builder: (context) => const GeneralServicesPage()),
  //               //     );
  //               //   },
  //               //   child: const Text(
  //               //     "رؤية الكل",
  //               //     style: TextStyle(color: Color(0xFF234F68)),
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //         ),
  //         FutureBuilder<List<Services>>(
  //             future: servicesDataList,
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<List<Services>> snapshot) {
  //               if (snapshot.connectionState == ConnectionState.done) {
  //                 if (snapshot.hasData && snapshot.hasError == false) {
  //                   return SizedBox(
  //                     height: 140,
  //                     child: ListView.builder(
  //                       itemExtent: size.width / 2,
  //                       shrinkWrap: true,
  //                       scrollDirection: Axis.horizontal,
  //                       itemCount: snapshot.data!.length,
  //                       itemBuilder: (context, index) {
  //                         return GestureDetector(
  //                           onTap: () {
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         SingleGeneralServicesPage(
  //                                           servicesDetails:
  //                                               snapshot.data![index],
  //                                         )));
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.all(4),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(25),
  //                             ),
  //                             child: Stack(
  //                               children: [
  //                                 Positioned.fill(
  //                                   child: ClipRRect(
  //                                     borderRadius: BorderRadius.circular(25),
  //                                     child: ColorFiltered(
  //                                       colorFilter: ColorFilter.mode(
  //                                         Colors.black.withOpacity(0.3),
  //                                         BlendMode.srcATop,
  //                                       ),
  //                                       child: Image.network(
  //                                         snapshot
  //                                             .data![index].attributes!.image!,
  //                                         fit: BoxFit.fill,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Column(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Container(
  //                                       margin: const EdgeInsets.only(
  //                                           top: 10, right: 30),
  //                                       child: Column(
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             snapshot.data![index].attributes!
  //                                                     .name ??
  //                                                 "",
  //                                             style: const TextStyle(
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.bold,
  //                                               height: 1,
  //                                             ),
  //                                           ),
  //                                           const SizedBox(height: 10),
  //                                           Text(
  //                                             snapshot.data![index].attributes!
  //                                                     .description ??
  //                                                 "",
  //                                             style: const TextStyle(
  //                                                 fontSize: 10,
  //                                                 color: Colors.white,
  //                                                 height: 1),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       padding: const EdgeInsets.symmetric(
  //                                         vertical: 10,
  //                                         horizontal: 23,
  //                                       ),
  //                                       decoration: const BoxDecoration(
  //                                         borderRadius: BorderRadius.only(
  //                                           topLeft: Radius.circular(25),
  //                                         ),
  //                                         color: Color(0xFF234F68),
  //                                       ),
  //                                       child: const Icon(
  //                                         Icons.arrow_forward_sharp,
  //                                         size: 30,
  //                                         color: Colors.white,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 } else if (snapshot.hasError) {
  //                   print("DATA ERROR ${snapshot.error}");
  //                   return const Center(
  //                       child: Padding(
  //                     padding: EdgeInsets.only(top: 16),
  //                     child: Text(errorWhileGetData),
  //                   ));
  //                 } else {
  //                   return const Center(
  //                       child: Padding(
  //                     padding: EdgeInsets.only(top: 16),
  //                     child: Text(noData),
  //                   ));
  //                 }
  //               } else if (snapshot.connectionState ==
  //                   ConnectionState.waiting) {
  //                 return const Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       SizedBox(
  //                         width: 60,
  //                         height: 60,
  //                         child: ColorLoader2(),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(top: 16),
  //                         child: Text(loadingDataFromServer),
  //                       )
  //                     ],
  //                   ),
  //                 );
  //               } else {
  //                 return const Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       SizedBox(
  //                         width: 60,
  //                         height: 60,
  //                         child: CircularProgressIndicator(),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(top: 16),
  //                         child: Text(loadingDataFromServer),
  //                       )
  //                     ],
  //                   ),
  //                 );
  //               }
  //             })
  //       ],
  //     ),
  //   );
  // }

// Most Requested widget
  Widget buildMostRequest() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الأكثر طلباً",
                style: TextStyle(
                    color: Color(0xFF234F68), fontWeight: FontWeight.w900),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MostRequestedServicesPage()),
                  );
                },
                child: const Text(
                  "رؤية الكل",
                  style: TextStyle(color: Color(0xFF234F68)),
                ),
              ),
            ],
          ),
          FutureBuilder<List<Services>>(
              future: subServicesDataList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Services>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.hasError == false) {
                    return SizedBox(
                      height: 104,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 15,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 15),
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
                                                  snapshot.data![index],
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(4),
                                          shape: const CircleBorder()),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundImage: NetworkImage(snapshot
                                            .data![index].attributes!.image!),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].attributes!.name!,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(4),
                              backgroundColor: const Color(0xFFF5F4F8),
                              foregroundColor: const Color(0xFF234F68),
                              fixedSize: const Size(double.infinity, 0),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MostRequestedServicesPage(),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.subdirectory_arrow_left_outlined),
                                SizedBox(height: 5),
                                Text("الكل"),
                              ],
                            ),
                          )
                        ],
                      ),
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
    );
  }
}
