import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tadllal/pages/home_page/widgets/locations_filter.dart';
import 'package:tadllal/pages/home_page/widgets/real_estate_filter.dart';
import 'package:tadllal/pages/home_page/widgets/real_estates.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildFilterMenu(),
            Row(
              children: [
                buildNotificationsIcon(true),
                const SizedBox(width: 15),
                buildUserImage(),
              ],
            ),
          ],
        ),
        buildService(),
        buildMostRequest(),
        const LocationFilter(),
        const RealEstateFilter(),
        const RealEstates()
      ],
    );
  }
}

// User image widget
Widget buildUserImage() {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFDFDFDF), width: 2),
    ),
    child: const CircleAvatar(
      radius: 28,
      backgroundImage: AssetImage(
        'assets/images/user.png',
      ),
    ),
  );
}

// Notifications icon widget
Widget buildNotificationsIcon(bool hasNotification) {
  return TextButton(
    style: TextButton.styleFrom(
      shape: const CircleBorder(),
    ),
    onPressed: () {},
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
        if (hasNotification)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFD5F4A),
                ),
              ),
            ),
          )
      ],
    ),
  );
}

// Filter menu widget
Widget buildFilterMenu() {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFDFDFDF), width: 2),
      ),
      child: DropdownButton(
        underline: const SizedBox(),
        icon: const Icon(
          Icons.keyboard_arrow_down_outlined,
        ),
        hint: Row(
          children: [
            const SizedBox(width: 10),
            SvgPicture.asset('assets/icons/filter-icon.svg'),
            const SizedBox(width: 10),
            const Text('فلترة المعروضات'),
            const SizedBox(width: 10),
          ],
        ),
        items: const [],
        onChanged: (value) {},
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "خدمات إنشائية وتوريدات",
            style: TextStyle(
                color: Color(0xFF234F68), fontWeight: FontWeight.w900),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "رؤية الكل",
              style: TextStyle(color: Color(0xFF234F68)),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: serviceData.map((data) {
          return TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
            ),
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(data['image'] ?? "", width: 190),
                ),
                Positioned(
                  right: 18,
                  top: 10,
                  child: Column(
                    children: [
                      Text(
                        data['title'] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data['subtitle'] ?? "",
                        style: const TextStyle(color: Colors.white, height: 1),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
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
                )
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}

// Most Requested widget
Widget buildMostRequest() {
  final List titles = [
    "ديكورات",
    "تصاميم هندسيه",
    "مقاولات",
    "حديد",
    "أسمنت",
  ];
  final List images = [
    "assets/request/decor.png",
    "assets/request/engineering-designs.png",
    "assets/request/construction.png",
    "assets/request/iron.png",
    "assets/request/cement.png",
  ];
  return Column(
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
            onPressed: () {},
            child: const Text(
              "رؤية الكل",
              style: TextStyle(color: Color(0xFF234F68)),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 104,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        shape: const CircleBorder()),
                    child: Image.asset(images[index]),
                  ),
                  Text(
                    titles[index],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}
