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
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  userImage(),
                  const SizedBox(width: 15),
                  notificationsIcon(true)
                ],
              ),
              filterMenu()
            ],
          )
        ],
      ),
    );
  }
}

// Users profile image widget
Widget userImage() {
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
Widget notificationsIcon(bool hasNotification) {
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
Widget filterMenu() {
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
          const Text('فلترة المعروضات'),
          const SizedBox(width: 10),
        ],
      ),
      items: const [],
      onChanged: (value) {},
    ),
  );
}
