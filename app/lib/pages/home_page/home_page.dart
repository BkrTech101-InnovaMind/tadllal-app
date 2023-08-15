import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tadllal/pages/general_services_page/general_services_page.dart';
import 'package:tadllal/pages/home_page/widgets/locations_filter.dart';
import 'package:tadllal/pages/home_page/widgets/real_estate_filter.dart';
import 'package:tadllal/pages/home_page/widgets/real_estates.dart';
import 'package:tadllal/pages/most_requested_services_page/most_requested_services_page.dart';
import 'package:tadllal/pages/single_sub_service_page/single_sub_service_page.dart';

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
                buildUserImage(context),
              ],
            ),
          ],
        ),
        buildService(context),
        buildMostRequest(context),
        const LocationFilter(),
        const RealEstateFilter(),
        const SizedBox(height: 20),
        const RealEstates()
      ],
    );
  }
}

// User image widget
Widget buildUserImage(BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(0),
    ),
    onPressed: () {},
    child: Container(
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
Widget buildService(context) {
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GeneralServicesPage()),
              );
            },
            child: const Text(
              "رؤية الكل",
              style: TextStyle(color: Color(0xFF234F68)),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 140,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemExtent: 200,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: serviceData.length,
          itemBuilder: (context, index) {
            return Container(
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
            );
          },
        ),
      )
    ],
  );
}

// Most Requested widget
Widget buildMostRequest(context) {
  final subServices = [
    {
      "title": "ديكورات",
      "image": "https://i.pravatar.cc/300",
      "sub_title":
          "تقدم خدمات تصميم وتنفيذ الديكورات الداخلية والخارجية، حيث نجمع بين الفن والابتكار لخلق أماكن رائعة ومميزة تعكس شخصية واحتياجات عملائنا. نحن نهتم بكل التفاصيل، من اختيار الألوان والمواد إلى توزيع الفراغات بطريقة تجمع بين الجمال والوظائف العملية."
    },
    {
      "title": "تصاميم هندسية",
      "image": "https://i.pravatar.cc/300",
      "sub_title":
          "نقدم خدمات تصميم وتخطيط مشاريع هندسية مبتكرة ومتطورة. فريقنا من المهندسين المحترفين يعمل على تحويل الأفكار إلى واقع من خلال تصاميم دقيقة واقتصادية. سواء كنت تبحث عن تصميم مبنى سكني أو تجاري، نحن هنا لنجعل رؤيتك تتحقق بأعلى معايير الجودة."
    },
    {
      "title": "مقاولات",
      "image": "https://i.pravatar.cc/300",
      "sub_title":
          "نحن شركة مقاولات متخصصة في إدارة وتنفيذ مشاريع البناء والإنشاء بكل احترافية وجودة. نقوم بتقديم خدمات متكاملة تشمل التخطيط والتنفيذ وإدارة المشاريع، مع التركيز على تحقيق الجودة والمواعيد الزمنية. نحن نضمن تنفيذ المشاريع بأعلى معايير الأمان والاستدامة."
    },
    {
      "title": "حديد",
      "image": "https://i.pravatar.cc/300",
      "sub_title":
          "نحن متخصصون في توريد وتركيب وتصنيع منتجات من الحديد والمعدن. نقدم تشكيلة واسعة من المنتجات التي تتضمن الأبواب، الشبابيك، السلالم، والأثاث المعدني. نحن نضمن جودة عالية وتصميمات مبتكرة، مع التركيز على تلبية احتياجات عملائنا بشكل فعال."
    },
    {
      "title": "أسمنت",
      "image": "https://i.pravatar.cc/300",
      "sub_title":
          "نحن شركة توريد وتوزيع مواد البناء والأسمنت والمواد الإنشائية. نقدم مجموعة متنوعة من المنتجات عالية الجودة لدعم مشاريع البناء والتشييد. نحن نهتم بتزويد عملائنا بالمواد ذات الجودة العالية والتي تلبي معايير الأمان والاستدامة."
    }
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MostRequestedServicesPage()),
              );
            },
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
          itemCount: subServices.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleSubServicesPage(
                              serviceDetails: subServices[index]),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        shape: const CircleBorder()),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          NetworkImage('${subServices[index]["image"]}'),
                    ),
                  ),
                  Text(
                    '${subServices[index]["title"]}',
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
