import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tadllal/config/config.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/model/real_estate.dart';
import 'package:tadllal/services/api/dio_api.dart';
import 'package:tadllal/widgets/LodingUi/Loder1.dart';
import 'package:tadllal/widgets/make_order_dialog.dart';

class RealEstateDetailsPage extends StatefulWidget {
  final RealEstate realEstate;

  const RealEstateDetailsPage({Key? key, required this.realEstate})
      : super(key: key);

  @override
  State<RealEstateDetailsPage> createState() => _RealEstateDetailsPageState();
}

class _RealEstateDetailsPageState extends State<RealEstateDetailsPage> {
  final DioApi dioApi = DioApi();
  Future<RealEstate> realEstateData = Future(() => RealEstate());
  final TextEditingController _commentController = TextEditingController();
  String commentId = "";

  @override
  void initState() {
    _syncData();
    super.initState();
  }

  Future<void> refresh() async {
    _syncData();
  }

  _syncData() {
    setState(() {
      realEstateData = _getRealEstateData();
    });
  }

  Future<RealEstate> _getRealEstateData() async {
    var rowData =
        await dioApi.get("/realEstate/realty/${widget.realEstate.id}");
    // log("rowData ${rowData}");
    RealEstate realEstate = RealEstate.fromJson(rowData.data["data"]);
    // log("jsonString ${jsonString}");

    return realEstate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.realEstate.attributes!.name!),
        backgroundColor: const Color(0xFF194706),
        actions: <Widget>[
          TextButton(
            child: const Text("طلب"),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context2) => MakeOrderDialog(
                    type: "RealEstate",
                    orderId: int.parse(widget.realEstate.id!)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<RealEstate>(
          future: realEstateData,
          builder: (BuildContext context, AsyncSnapshot<RealEstate> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.hasError == false) {
                return ListView(
                  children: [
                    buildImagesSection(realEstate: snapshot.data!),
                    buildDetailsSection(realEstate: snapshot.data!),
                    buildCommentsSection(realEstate: snapshot.data!),
                  ],
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
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
      bottomNavigationBar: _userAddComment(),
    );
  }

  // Images section
  Widget buildImagesSection({required RealEstate realEstate}) {
    return CarouselSlider(
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
                        backgroundColor: const Color(0xFF194706),
                      ),
                      body: Center(
                        child: PhotoView(
                          loadingBuilder: (context, event) => Center(
                            child: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: CircularProgressIndicator(
                                backgroundColor: const Color(0xFFE0A410),
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                        event.expectedTotalBytes!,
                              ),
                            ),
                          ),
                          imageProvider: NetworkImage(image),
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.contained * 2,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            child: Image.network(image,
                fit: BoxFit.contain, filterQuality: FilterQuality.high),
          );
        },
      ).toList(),
    );
  }

// Details section
  Widget buildDetailsSection({required RealEstate realEstate}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Type Texts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title Text
              Text.rich(
                TextSpan(
                  text: "ألعنوان: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\n${realEstate.attributes!.name!}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),

              // Type Text
              Text.rich(
                TextSpan(
                  text: "التصنيف: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\n${realEstate.attributes!.firstType!.name}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Price & Availability Texts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price Text
              Text.rich(
                TextSpan(
                  text: "ألسعر: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\n${realEstate.attributes!.price!}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    const TextSpan(
                        text: " \$",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Availability Text
              Text.rich(
                TextSpan(
                  text: "ألحالة: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\n${realEstate.attributes!.state}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Location & Rating Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location Text
              Text.rich(
                TextSpan(
                  text: "ألموقع: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\n${realEstate.attributes!.location!.name}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),

              // Rating Text
              Text.rich(
                TextSpan(
                  text: "ألتقييم: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text:
                          "\n${realEstate.attributes!.ratings!.averageRating}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Description Text
          Text.rich(
            TextSpan(
              text: "الوصف: ",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: "\n${realEstate.attributes!.description}",
                  style: const TextStyle(fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

// Comments Section
  Widget buildCommentsSection({required RealEstate realEstate}) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text("التعليقات: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _buildComment(realEstate),
      ],
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
          //height: 600.0,
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
                      FontAwesomeIcons.userAlt,
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
                            dioApi.delete(
                                "/comments/comment/${realEstate.attributes!.comments![index].id!}",
                                myData: {
                                  "comment": _commentController.text.trim()
                                }).then((value) {
                              _syncData();
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
                            // dioApi.post("/comments/add/${widget.realEstate.id}", myData: {"comment":_commentController.text.trim()}).then((value) {
                            //   _commentController.clear();
                            //
                            // });
                            commentId =
                                realEstate.attributes!.comments![index].id!;
                            _commentController.text = realEstate.attributes!
                                .comments![index].attributes!.comment!;
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

  Widget _userAddComment() {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        //color: Colors.white,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -10),
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 2, bottom: 12, right: 12, left: 12),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.all(15.0),
              hintText: 'اكتب تعليقك',
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
              prefixIcon: Container(
                  margin: const EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
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
                      imageUrl: "${Config().user.attributes!.avatar}",
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
                        FontAwesomeIcons.user,
                        color: Color(0xFFFF4700),
                        size: 35,
                      ),
                    )),
                  )),
              suffixIcon: Container(
                margin: const EdgeInsets.only(left: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(1, 5),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                width: 70.0,
                child: TextButton(
                  onPressed: () {
                    if (commentId.isEmpty) {
                      dioApi.post("/comments/add/${widget.realEstate.id}",
                          myData: {
                            "comment": _commentController.text.trim()
                          }).then((value) {
                        _commentController.clear();
                        _syncData();
                      });
                    } else {
                      dioApi.put("/comments/comment/$commentId", myData: {
                        "comment": _commentController.text.trim()
                      }).then((value) {
                        _commentController.clear();
                        commentId = "";
                        _syncData();
                      });
                    }
                  },
                  child: const Icon(
                    FontAwesomeIcons.paperPlane,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
