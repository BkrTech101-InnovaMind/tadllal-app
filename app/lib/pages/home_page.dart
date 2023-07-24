import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            Row(
              children: [
                buildUserImage(),
                const SizedBox(width: 15),
                buildNotificationsIcon(true)
              ],
            ),
            buildFilterMenu()
          ],
        ),
        buildService(),
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
      backgroundImage: NetworkImage(
        'https://picsum.photos/200/300',
      ),
    ),
  );
}

// Notifications icon widget
Widget buildNotificationsIcon(bool hasNotification) {
  return Stack(
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
  );
}

// Filter menu widget
Widget buildFilterMenu() {
  return Container(
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
          const Text('Filter Displayed'),
          const SizedBox(width: 10),
        ],
      ),
      items: const [],
      onChanged: (value) {},
    ),
  );
}

// service Widget
Widget buildService() {
  final serviceData = [
    {
      'image': 'assets/images/resources.png',
      'title': 'موارد بناء وتوريدات',
      'subtitle': 'أطلب أي مواد تحتاجها لبناء \n حلمك',
    },
    {
      'image': 'assets/images/services.png',
      'title': 'خدمات إنشائية \n وصيانة',
      'subtitle': 'خدمات تصميم وتنفيذ',
    },
  ];

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "رؤية الكل",
              style: TextStyle(color: Color(0xFF234F68)),
            ),
          ),
          const Text(
            "خدمات إنشائية وتوريدات",
            style: TextStyle(
              color: Color(0xFF234F68),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: serviceData.map((data) {
          return Stack(
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
                      textAlign: TextAlign.right,
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
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white, height: 1),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    backgroundColor: const Color(0xFF234F68),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Icon(
                    Icons.arrow_back_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        }).toList(),
      ),
    ],
  );
}
