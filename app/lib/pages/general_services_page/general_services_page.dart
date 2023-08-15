import 'package:flutter/material.dart';
import 'package:tadllal/pages/single_sub_service_page/single_sub_service_page.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

final generalServices = [
  {
    'image': "https://i.pravatar.cc/300",
    'title': 'خدمات إنشائية \n وصيانة',
    'sub_title': 'خدمات تصميم وتنفيذ',
  },
  {
    'image': "https://i.pravatar.cc/300",
    'title': 'موارد بناء وتوريدات',
    'sub_title': 'أطلب أي مواد تحتاجها لبناء \n حلمك',
  },
];

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

class GeneralServicesPage extends StatefulWidget {
  const GeneralServicesPage({super.key});

  @override
  State<GeneralServicesPage> createState() => _GeneralServicesPageState();
}

class _GeneralServicesPageState extends State<GeneralServicesPage> {
  final generalService = generalServices;
  final subService = subServices;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("كل الخدمات الإنشائية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: generalService.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      '${generalService[index]["image"]}',
                    ),
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.srcATop,
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TapToExpand(
                  openedHeight: 200,
                  closedHeight: 68,
                  scrollable: true,
                  scrollPhysics: const BouncingScrollPhysics(),
                  onTapPadding: 0,
                  color: Colors.transparent,
                  boxShadow: const [BoxShadow(color: Colors.transparent)],
                  duration: const Duration(seconds: 1),
                  content: Column(
                    children: [
                      Text("${generalService[index]["sub_title"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Card(
                        elevation: 0,
                        color: Colors.white.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: 89,
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
                                            builder: (context) =>
                                                SingleSubServicesPage(
                                              serviceDetails:
                                                  subServices[index],
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(4),
                                          shape: const CircleBorder()),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundImage: NetworkImage(
                                            '${subServices[index]["image"]}'),
                                      ),
                                    ),
                                    Text('${subServices[index]["title"]}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    "${generalService[index]['title']}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
