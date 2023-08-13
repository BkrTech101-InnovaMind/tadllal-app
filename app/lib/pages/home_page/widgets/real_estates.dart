import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tadllal/pages/real_estate_details_page/real_estate_details_page.dart';

class RealEstates extends StatefulWidget {
  const RealEstates({super.key});

  @override
  State<RealEstates> createState() => _RealEstatesState();
}

class _RealEstatesState extends State<RealEstates> {
  final List realEstates = [
    {
      'images': [
        'assets/images/shape.png',
        'assets/images/shape2.png',
        'assets/images/shape3.png',
        'assets/images/shape4.png',
      ],
      "availability": "متاح",
      "state": "للإيجار",
      "location": "حدة,حي العفيفة",
      "price": "220",
      "type": "أرض",
      "title": "شقة مفروشة للإيجار",
      "description":
          "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
      "rating": "4.8",
      "isFavorite": false
    },
    {
      'images': [
        'assets/images/shape.png',
        'assets/images/shape2.png',
        'assets/images/shape3.png',
        'assets/images/shape4.png',
      ],
      "availability": "غير متاح",
      "state": "للبيع",
      "type": "شقة",
      "location": "بيت بوس, حي الشباب",
      "price": "500,000",
      "title": "فيلا بتصميم حديث",
      "description":
          "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
      "rating": "4.8",
      "isFavorite": false
    },
    {
      'images': [
        'assets/images/shape.png',
        'assets/images/shape2.png',
        'assets/images/shape3.png',
        'assets/images/shape4.png',
      ],
      "availability": "متاح",
      "state": "للإيجار",
      "type": "عمارة",
      "location": "بيت بوس, حي الشباب",
      "price": "235",
      "title": "فيلا واسعة للإيجار",
      "description":
          "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
      "rating": "4.8",
      "isFavorite": false
    },
    {
      'images': [
        'assets/images/shape.png',
        'assets/images/shape2.png',
        'assets/images/shape3.png',
        'assets/images/shape4.png',
      ],
      "availability": "غير متاح",
      "state": "للبيع",
      "type": "فلة",
      "location": "حدة,شارع بيروت",
      "price": "56,000",
      "title": "شقة للبيع في برج حديث وفي موقع متميز",
      "description":
          "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
      "rating": "4.8",
      "isFavorite": false
    },
  ];
  void toggleFavorite(int index) {
    setState(() {
      realEstates[index]['isFavorite'] = !realEstates[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicHeightGridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      itemCount: realEstates.length,
      builder: (context, index) {
        bool favoriteColor = realEstates[index]['isFavorite'];
        String state = "${realEstates[index]['state']}";
        Color backgroundColor;
        if (state == "للإيجار") {
          backgroundColor = const Color(0xFFA82727);
        } else {
          backgroundColor = const Color(0xFFFA712D);
        }
        return TextButton(
          style: TextButton.styleFrom(padding: const EdgeInsets.all(5)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RealEstateDetailsPage(realEstate: realEstates[index]);
            }));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xFFF5F4F8),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(realEstates[index]['images'][0]),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    height: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  child: GestureDetector(
                                    onTap: () {
                                      toggleFavorite(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: favoriteColor
                                            ? const Color(0xFF8BC83F)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/favorites-icon.svg",
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                          favoriteColor
                                              ? Colors.white
                                              : const Color(0xFFFD5F4A),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: Text(
                                "${realEstates[index]['state']}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF234F68).withOpacity(0.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '\$ ${realEstates[index]['price']}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(5.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${realEstates[index]['title']}",
                        style: const TextStyle(
                          color: Color(0xFF234F68),
                          fontWeight: FontWeight.bold,
                          height: 1,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF234F68),
                              ),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  "${realEstates[index]['location']}",
                                  style: const TextStyle(
                                    color: Color(0xFF234F68),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${realEstates[index]['rating']}",
                                style: const TextStyle(
                                  color: Color(0xFF234F68),
                                ),
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
