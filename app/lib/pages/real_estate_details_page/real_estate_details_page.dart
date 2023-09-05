import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/LodingUi/Loder1.dart';
import 'package:tedllal/widgets/comment_dialog.dart';
import 'package:tedllal/widgets/make_order_dialog.dart';

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
    setState(() {
      realEstateData = _getRealEstateData();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRatingDialog(),
        backgroundColor: const Color(0xFF194706),
        child: const Icon(Icons.add_comment_outlined),
      ),
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
                                      TextButton(
                                          onPressed: () {
                                            dioApi
                                                .delete(
                                                    "/comments/comment/${realEstate.attributes!.comments![index].id!}",
                                                    myData: {
                                                      "comment":
                                                          _commentController
                                                              .text
                                                              .trim()
                                                    })
                                                .then((value) {
                                                  _syncData();
                                                })
                                                .then((value) =>
                                                    Navigator.pop(context))
                                                .then(
                                                  (value) =>
                                                      ScaffoldMessenger.of(
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
                                          child: const Text("حذف")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("الغاء"))
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
