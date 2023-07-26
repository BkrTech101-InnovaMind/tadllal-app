import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RealEstates extends StatefulWidget {
  const RealEstates({super.key});

  @override
  State<RealEstates> createState() => _RealEstatesState();
}

class _RealEstatesState extends State<RealEstates> {
  final List realEstates = [
    {
      'image': 'assets/images/shape.png',
      "state": "للإيجار",
      "location": "حدة,حي العفيفة",
      "price": "220",
      "title": "شقة مفروشة للإيجار",
      "rating": "4.8",
      "isFavorite": false
    },
    {
      'image': 'assets/images/shape2.png',
      "state": "للبيع",
      "location": "حدة,حي العفيفة",
      "price": "220",
      "title": "شقة مفروشة للإيجار",
      "rating": "4.8",
      "isFavorite": false
    },
    {
      'image': 'assets/images/shape3.png',
      "state": "للبيع",
      "location": "حدة,حي العفيفة",
      "price": "220",
      "title": "شقة مفروشة للإيجار",
      "rating": "4.8",
      "isFavorite": false
    },
    {
      'image': 'assets/images/shape4.png',
      "state": "للإيجار",
      "location": "حدة,حي العفيفة",
      "price": "220",
      "title": "شقة مفروشة للإيجار",
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: realEstates.length,
      itemBuilder: (context, index) {
        bool favoriteColor = realEstates[index]['isFavorite'];
        String state = realEstates[index]['state'] ?? "";
        Color backgroundColor = const Color(0xFFA82727);
        if (state == "للإيجار") {
          backgroundColor = const Color(0xFFA82727);
        } else {
          backgroundColor = const Color(0xFFFA712D);
        }
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFDFDFDF),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(realEstates[index]['image'] ?? ""),
                fit: BoxFit.fill,
              ),
            ),
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
                                    Radius.circular(100)),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/favorites-icon.svg',
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
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: Text(
                        realEstates[index]['state'] ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF234F68).withOpacity(0.7),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    realEstates[index]['price'] ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
