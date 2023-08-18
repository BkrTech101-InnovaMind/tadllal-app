import 'package:flutter/material.dart';
import 'package:tadllal/pages/general_services_page/general_services_page.dart';
import 'package:tadllal/pages/home_page/widgets/locations_filter.dart';
import 'package:tadllal/pages/home_page/widgets/menu_filter.dart';
import 'package:tadllal/pages/home_page/widgets/real_estate_filter.dart';
import 'package:tadllal/pages/home_page/widgets/real_estates.dart';
import 'package:tadllal/pages/most_requested_services_page/most_requested_services_page.dart';
import 'package:tadllal/pages/notification_page/notification_page.dart';
import 'package:tadllal/pages/single_general_services_page/single_general_services_page.dart';
import 'package:tadllal/pages/single_sub_service_page/single_sub_service_page.dart';

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: HalfCircleClipper(),
            child: Container(
              height: 300,
              color: const Color(0xFFE3E3E3),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MenuFilter(),
                      Row(
                        children: [
                          buildNotificationsIcon(true),
                          const SizedBox(width: 15),
                          buildUserImage(),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      buildService(),
                      buildMostRequest(),
                      const LocationFilter(),
                      const RealEstateFilter(),
                      const SizedBox(height: 20),
                      const RealEstates(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// User image widget
  Widget buildUserImage() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
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
            radius: 30,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
        ),
      ),
    );
  }

// Notifications icon widget
  Widget buildNotificationsIcon(bool hasNotification) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationPage(
                isHasNotification: hasNotification,
              ),
            ),
          );
        },
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
            Visibility(
              visible: hasNotification,
              child: Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFD5F4A),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// service Widget
  Widget buildService() {
    final List<Map<String, dynamic>> serviceData = [
      {
        'image': "https://i.pravatar.cc/300",
        'title': 'خدمات إنشائية وصيانة',
        'subtitle': 'خدمات تصميم وتنفيذ',
        "subServices": [
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
        ],
      },
      {
        'image': "https://i.pravatar.cc/300",
        'title': 'موارد بناء وتوريدات',
        'subtitle': 'أطلب أي مواد تحتاجها لبناء \n حلمك',
        "subServices": [
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
        ],
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
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
              physics: const BouncingScrollPhysics(),
              itemExtent: 200,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: serviceData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleGeneralServicesPage(
                                generalServiceDetails: serviceData[index])));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.srcATop,
                              ),
                              child: Image.network(
                                serviceData[index]['image'].toString(),
                                fit: BoxFit.fill,
                              ),
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
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

// Most Requested widget
  Widget buildMostRequest() {
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
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
                        builder: (context) =>
                            const MostRequestedServicesPage()),
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
              physics: const BouncingScrollPhysics(),
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
      ),
    );
  }
}
