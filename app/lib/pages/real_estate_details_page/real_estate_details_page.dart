import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/comment_dialog.dart';
import 'package:tedllal/widgets/loading_ui/loader1.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';
import 'package:tedllal/widgets/make_order_dialog.dart';
import 'package:tedllal/widgets/pages_back_button.dart';

class RealEstateDetailsPage extends StatefulWidget {
  final RealEstate realEstate;
  const RealEstateDetailsPage({required this.realEstate, super.key});

  @override
  State<RealEstateDetailsPage> createState() => _RealEstateDetailsPageState();
}

class _RealEstateDetailsPageState extends State<RealEstateDetailsPage> {
  final DioApi dioApi = DioApi();
  Future<RealEstate> realEstateData = Future(() => RealEstate());
  List<RealEstate> linkedRealEstateList = [];
  final TextEditingController _commentController = TextEditingController();
  String commentId = "";
  double rating = 0;

  @override
  void initState() {
    _syncData();
    super.initState();
  }

  Future<void> refresh() async {
    _syncData();
  }

  _syncData() {
    realEstateData = _getRealEstateData();
    realEstateData.then((value) {
      _getLinkedRealEstateDataList(mainRealEstate: value).then((value) {
        setState(() {
          linkedRealEstateList = value;
        });
      });
    });
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (_) => CommentDialog(
        commentController: _commentController,
        commentId: commentId,
        rating: rating,
        realEstate: widget.realEstate,
        syncData: _syncData,
      ),
    );
  }

  Future<RealEstate> _getRealEstateData() async {
    var rowData =
        await dioApi.get("/realEstate/realty/${widget.realEstate.id}");
    RealEstate realEstate = RealEstate.fromJson(rowData.data["data"]);
    return realEstate;
  }

  Future<List<RealEstate>> _getLinkedRealEstateDataList(
      {required RealEstate mainRealEstate}) async {
    var rowData = await dioApi.get("/realEstate/realty");
    String jsonString = json.encode(rowData.data["data"]);
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    List<RealEstate> realEstate =
        (data).map((itemWord) => RealEstate.fromJson(itemWord)).toList();
    realEstate = realEstate
        .where((element) =>
            element.attributes!.firstType!.name ==
            mainRealEstate.attributes!.firstType!.name)
        .toList();
    return realEstate;
  }

  void _onPressed() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context2) => MakeOrderDialog(
        type: "RealEstate",
        orderId: int.parse(widget.realEstate.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
                border: Border(bottom: BorderSide(color: Color(0xFFF5F4F8))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                      'طلب العقار',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<RealEstate>(
                  future: realEstateData,
                  builder: (BuildContext context,
                      AsyncSnapshot<RealEstate> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.hasError == false) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            buildImagesSection(realEstate: snapshot.data!),
                            buildDetailsSection(realEstate: snapshot.data!),
                            buildSameType(
                              linkedRealEstateFuture:
                                  _getLinkedRealEstateDataList(
                                      mainRealEstate: snapshot.data!),
                            ),
                            buildCommentsSection(realEstate: snapshot.data!),
                          ],
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
                              child: ColorLoader1(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showRatingDialog(),
          backgroundColor: const Color(0xFFF5F4F8),
          foregroundColor: const Color(0xFF1F4C6B),
          child: const Icon(Icons.add_comment_outlined),
        ),
      ),
    );
  }

  // Images section
  Widget buildImagesSection({required RealEstate realEstate}) {
    return realEstate.attributes!.images!.isNotEmpty
        ? Container(
            decoration: const BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1)
                ]),
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 0.5,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: 16 / 9,
              ),
              items: realEstate.attributes!.images!.map<Widget>(
                (image) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(realEstate.attributes!.name!),
                                backgroundColor: Colors.transparent,
                              ),
                              body: Center(
                                child: PhotoView(
                                  loadingBuilder: (context, event) => Center(
                                    child: SizedBox(
                                      width: 30.0,
                                      height: 30.0,
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            const Color(0xFFE0A410),
                                        value: event == null
                                            ? 0
                                            : event.cumulativeBytesLoaded /
                                                event.expectedTotalBytes!,
                                      ),
                                    ),
                                  ),
                                  imageProvider:
                                      CachedNetworkImageProvider(image),
                                  minScale:
                                      PhotoViewComputedScale.contained * 0.8,
                                  maxScale:
                                      PhotoViewComputedScale.contained * 2,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          )
        : Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1)
                ]),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "لا يوجد صور",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          );
  }

  // Details section
  Widget buildDetailsSection({required RealEstate realEstate}) {
    String state = realEstate.attributes!.secondType!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "الإسم",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.5,
                    ),
                    child: Text(
                      realEstate.attributes!.name!,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Divider(color: Colors.lightGreen, thickness: 3),
                  ),
                ],
              ),
            ],
          ),
          // Details Text
          const SizedBox(height: 25),
          const Text(
            "التفاصيل :",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Description Text
          const SizedBox(height: 15),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text(
              "الوصف",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightGreen,
              ),
            ),
            subtitle: Text(
              realEstate.attributes!.description!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 1)
                  ]),
              child: const Icon(
                Icons.description_outlined,
                color: Color(0xFFE0A410),
                size: 40,
              ),
            ),
          ),
          // Type & Rating Texts
          const SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "التصنيف",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  subtitle: Text(
                    realEstate.attributes!.firstType!.name!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 1)
                        ]),
                    child: const Icon(
                      Icons.type_specimen_outlined,
                      color: Color(0xFFE0A410),
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "التقييم",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  subtitle: Text(
                    realEstate.attributes!.ratings!.averageRating!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 1)
                        ]),
                    child: const Icon(
                      Icons.star_border_outlined,
                      color: Color(0xFFE0A410),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Price & state Texts
          const SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "الحالة",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  subtitle: Text(
                    state == "for rent" ? "للإيجار" : "للبيع",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 1)
                        ]),
                    child: const Icon(
                      Icons.home_work_outlined,
                      color: Color(0xFFE0A410),
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "السعر",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  subtitle: Text.rich(
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                    TextSpan(
                        text: realEstate.attributes!.price.toString(),
                        children: const [
                          TextSpan(
                            text: " \$",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 1)
                        ]),
                    child: const Icon(
                      Icons.attach_money_outlined,
                      color: Color(0xFFE0A410),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Area & Rooms Texts
          const SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "المساحة",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  subtitle: Text(
                    realEstate.attributes!.area!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 1)
                        ]),
                    child: const Icon(
                      Icons.space_bar_outlined,
                      color: Color(0xFFE0A410),
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "الغرف",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  subtitle: Text(
                    realEstate.attributes!.rooms!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 1)
                        ]),
                    child: const Icon(
                      Icons.meeting_room_outlined,
                      color: Color(0xFFE0A410),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Location Text
          const SizedBox(height: 15),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text(
              "الموقع",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightGreen,
              ),
            ),
            subtitle: Text(
              realEstate.attributes!.locationInfo!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 1)
                  ]),
              child: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFFE0A410),
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 15),
          buildMoreDetails(realEstate)
        ],
      ),
    );
  }

  // More Details
  Widget buildMoreDetails(RealEstate realEstate) {
    return Visibility(
      visible: realEstate.attributes!.vision! != "" ||
          realEstate.attributes!.baptism! != "",
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text(
              "تفاصيل إضافية: ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Vision & Baptism Texts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: realEstate.attributes!.vision! != "",
                        child: Text.rich(
                          TextSpan(
                            text: "البصيرة",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: " : ${realEstate.attributes!.vision!}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: realEstate.attributes!.baptism! != "",
                        child: Text.rich(
                          TextSpan(
                            text: "التعميد",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: " : ${realEstate.attributes!.baptism!}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Same Type
  Widget buildSameType(
      {required Future<List<RealEstate>> linkedRealEstateFuture}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: const Text(
            "عناصر مشابهة :",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FutureBuilder<List<RealEstate>>(
          future: linkedRealEstateFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<RealEstate>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 240,
                  child: Column(
                    children: [
                      ColorLoader2(),
                      Text("يجري جلب البيانات"),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('خطأ: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('لا توجد عناصر مشابهة'),
              );
            } else {
              List<RealEstate> linkedRealEstateList = snapshot.data!;
              return _buildSameTypeCarousel(
                  linkedRealEstateList: linkedRealEstateList);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSameTypeCarousel(
      {required List<RealEstate> linkedRealEstateList}) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.5,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        enableInfiniteScroll: linkedRealEstateList.length > 3,
        aspectRatio: 16 / 9.6,
      ),
      items: linkedRealEstateList
          .map<Widget>(
            (realEstate) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RealEstateDetailsPage(
                      realEstate: realEstate,
                    ),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: const BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Real Estate Image
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl: realEstate.attributes!.photo!,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    // Real Estate Details
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text(
                          "العنوان",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          realEstate.attributes!.name!,
                          textScaleFactor: 1.2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Text.rich(
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      TextSpan(text: "التقييم", children: [
                        TextSpan(
                          text:
                              ": ${realEstate.attributes!.ratings!.averageRating!}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

// Comments Section
  Widget buildCommentsSection({required RealEstate realEstate}) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("التعليقات: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildComment(realEstate),
        ],
      ),
    );
  }

  Widget _buildComment(RealEstate realEstate) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: realEstate.attributes!.comments!.length,
      itemBuilder: (_, index) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Container(
                width: 50.0,
                height: 50.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl:
                        "${realEstate.attributes!.comments![index].attributes!.userImage}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      FontAwesomeIcons.userLarge,
                      color: Color(0xFFFF4700),
                      size: 35,
                    ),
                  )),
                ),
              ),
              title: Text(
                  realEstate.attributes!.comments![index].attributes!.userName!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    realEstate
                        .attributes!.comments![index].attributes!.comment!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                  if (Config().user.id ==
                      realEstate.attributes!.comments![index].attributes!.userId
                          .toString()) ...{
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Text("هل متأكد من حذف التعليق ؟"),
                                    actions: [
                                      MaterialButton(
                                        height: 30.0,
                                        minWidth: 50.0,
                                        color: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        textColor: Colors.white,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        splashColor: Colors.redAccent,
                                        child: const Text(
                                          'إلغاء',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      MaterialButton(
                                        height: 30.0,
                                        minWidth: 50.0,
                                        color: const Color(0xFF8BC83F),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        textColor: Colors.white,
                                        onPressed: () {
                                          dioApi
                                              .delete(
                                                  "/comments/comment/${realEstate.attributes!.comments![index].id!}",
                                                  myData: {
                                                    "comment":
                                                        _commentController.text
                                                            .trim()
                                                  })
                                              .then((value) {
                                                _syncData();
                                              })
                                              .then((value) =>
                                                  Navigator.pop(context))
                                              .then(
                                                (value) => ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "تم الحذف بنجاح",
                                                    ),
                                                  ),
                                                ),
                                              );
                                        },
                                        splashColor: const Color(0xFF8BC83F),
                                        child: const Text(
                                          'تأكيد',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: const Icon(
                            FontAwesomeIcons.trash,
                            size: 15.0,
                            color: Colors.red,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            commentId =
                                realEstate.attributes!.comments![index].id!;
                            _commentController.text = realEstate.attributes!
                                .comments![index].attributes!.comment!;
                            _showRatingDialog();
                          },
                          child: const Icon(
                            FontAwesomeIcons.marker,
                            size: 15.0,
                            color: Color(0xFF194706),
                          ),
                        ),
                      ],
                    ),
                  }
                ],
              ),
              dense: true,
            ),
          ),
        );
      },
    );
  }
}
