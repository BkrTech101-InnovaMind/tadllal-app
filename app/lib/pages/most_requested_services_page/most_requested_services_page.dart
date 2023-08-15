import 'package:flutter/material.dart';

final subServices = [
  {
    "name": "ديكورات",
    "image": "assets/request/decor.png",
    "description": "خدمات تصميم وتنفيذ الديكورات الداخلية والخارجية."
  },
  {
    "name": "تصاميم هندسيه",
    "image": "assets/request/engineering-designs.png",
    "description": "تصميم وتخطيط للمشاريع الهندسية والإنشائية."
  },
  {
    "name": "مقاولات",
    "image": "assets/request/construction.png",
    "description": "خدمات المقاولات وإدارة وتنفيذ مشاريع البناء والإنشاء."
  },
  {
    "name": "حديد",
    "image": "assets/request/iron.png",
    "description": "توريد وتركيب وتصنيع منتجات من الحديد والمعدن."
  },
  {
    "name": "أسمنت",
    "image": "assets/request/cement.png",
    "description": "توريد وتوزيع مواد البناء والأسمنت والمواد الإنشائية."
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
                onTap: () {},
                leading: CircleAvatar(
                    backgroundImage: AssetImage("${services[index]['image']}")),
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
