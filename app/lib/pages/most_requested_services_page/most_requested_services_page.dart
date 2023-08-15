import 'package:flutter/material.dart';
import 'package:tadllal/pages/single_service_page/single_service_page.dart';

final subServices = [
  {
    "name": "ديكورات",
    "image": "https://i.pravatar.cc/300",
    "description":
        "تقدم خدمات تصميم وتنفيذ الديكورات الداخلية والخارجية، حيث نجمع بين الفن والابتكار لخلق أماكن رائعة ومميزة تعكس شخصية واحتياجات عملائنا. نحن نهتم بكل التفاصيل، من اختيار الألوان والمواد إلى توزيع الفراغات بطريقة تجمع بين الجمال والوظائف العملية."
  },
  {
    "name": "تصاميم هندسية",
    "image": "https://i.pravatar.cc/300",
    "description":
        "نقدم خدمات تصميم وتخطيط مشاريع هندسية مبتكرة ومتطورة. فريقنا من المهندسين المحترفين يعمل على تحويل الأفكار إلى واقع من خلال تصاميم دقيقة واقتصادية. سواء كنت تبحث عن تصميم مبنى سكني أو تجاري، نحن هنا لنجعل رؤيتك تتحقق بأعلى معايير الجودة."
  },
  {
    "name": "مقاولات",
    "image": "https://i.pravatar.cc/300",
    "description":
        "نحن شركة مقاولات متخصصة في إدارة وتنفيذ مشاريع البناء والإنشاء بكل احترافية وجودة. نقوم بتقديم خدمات متكاملة تشمل التخطيط والتنفيذ وإدارة المشاريع، مع التركيز على تحقيق الجودة والمواعيد الزمنية. نحن نضمن تنفيذ المشاريع بأعلى معايير الأمان والاستدامة."
  },
  {
    "name": "حديد",
    "image": "https://i.pravatar.cc/300",
    "description":
        "نحن متخصصون في توريد وتركيب وتصنيع منتجات من الحديد والمعدن. نقدم تشكيلة واسعة من المنتجات التي تتضمن الأبواب، الشبابيك، السلالم، والأثاث المعدني. نحن نضمن جودة عالية وتصميمات مبتكرة، مع التركيز على تلبية احتياجات عملائنا بشكل فعال."
  },
  {
    "name": "أسمنت",
    "image": "https://i.pravatar.cc/300",
    "description":
        "نحن شركة توريد وتوزيع مواد البناء والأسمنت والمواد الإنشائية. نقدم مجموعة متنوعة من المنتجات عالية الجودة لدعم مشاريع البناء والتشييد. نحن نهتم بتزويد عملائنا بالمواد ذات الجودة العالية والتي تلبي معايير الأمان والاستدامة."
  }
];

class MostRequestedServicesPage extends StatefulWidget {
  const MostRequestedServicesPage({super.key});

  @override
  State<MostRequestedServicesPage> createState() =>
      _MostRequestedServicesPageState();
}

class _MostRequestedServicesPageState extends State<MostRequestedServicesPage> {
  final services = subServices;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ألخدمات الاكثر طلباً"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(top: 10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleServicesPage(
                          serviceDetails: subServices[index]),
                    ),
                  );
                },
                leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage("${services[index]['image']}")),
                title: Text("${services[index]['name']}"),
                subtitle: Text(
                  "${services[index]['description']}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
