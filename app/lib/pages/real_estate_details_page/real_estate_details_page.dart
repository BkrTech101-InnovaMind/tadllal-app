import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tadllal/model/real_estate.dart';
import 'package:tadllal/widgets/LodingUi/make_order_dialog.dart';

class RealEstateDetailsPage extends StatefulWidget {
  final RealEstate realEstate;

  const RealEstateDetailsPage({Key? key, required this.realEstate})
      : super(key: key);

  @override
  State<RealEstateDetailsPage> createState() => _RealEstateDetailsPageState();
}

class _RealEstateDetailsPageState extends State<RealEstateDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.realEstate.attributes!.name!),
        backgroundColor: const Color(0xFF194706),
      ),
      body: ListView(
        children: [
          buildImagesSection(),
          buildDetailsSection(),
          buildCommentsSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF194706),
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context2) => MakeOrderDialog(
                type: "RealEstate", orderId: int.parse(widget.realEstate.id!)),
          );
        },
      ),
    );
  }

  // Images section
  Widget buildImagesSection() {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.5,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        aspectRatio: 16 / 9,
      ),
      items: widget.realEstate.attributes!.images!.map<Widget>(
        (image) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(widget.realEstate.attributes!.name!),
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
  Widget buildDetailsSection() {
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
                      text: "\n${widget.realEstate.attributes!.name!}",
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
                      text:
                          "\n${widget.realEstate.attributes!.firstType!.name}",
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
                      text: "\n${widget.realEstate.attributes!.price!}",
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
                      text: "\n${widget.realEstate.attributes!.state}",
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
                      text: "\n${widget.realEstate.attributes!.location!.name}",
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
                          "\n${widget.realEstate.attributes!.ratings!.averageRating}",
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
                  text: "\n${widget.realEstate.attributes!.description}",
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
  Widget buildCommentsSection() {
    final fakeComments = [
      {
        "id": 1,
        "username": "مستخدم1",
        "comment": "تعليق رائع على التصميم!",
        "avatar":
            "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
      },
      {
        "id": 2,
        "username": "مستخدم2",
        "comment": "أحببت هذا التطبيق!",
        "avatar":
            "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
      },
      {
        "id": 3,
        "username": "مستخدم3",
        "comment": "عمل مذهل، استمروا!",
        "avatar":
            "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
      }
    ];
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text("التعليقات: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fakeComments.length,
          itemBuilder: (_, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("${fakeComments[index]["avatar"]}"),
              ),
              title: Text(
                "${fakeComments[index]["username"]}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${fakeComments[index]["comment"]}"),
            );
          },
        ),
      ],
    );
  }
}
