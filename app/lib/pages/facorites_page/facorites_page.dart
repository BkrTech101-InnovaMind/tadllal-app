import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tadllal/pages/real_estate_details_page/real_estate_details_page.dart';

final realEstatesApiExample = [
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
];

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> realEstateFetcher = realEstatesApiExample;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مفضلاتي", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            const Text(
              "هنا يتم استعراض ماقمت بتفضيله من عناصر ",
              style: TextStyle(fontSize: 18, color: Color(0xFF234F68)),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: realEstateFetcher.length,
              itemBuilder: (context, index) {
                final realEstate = realEstateFetcher[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20, left: 10, right: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F4F8),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.2,
                      children: slidableChildren,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RealEstateDetailsPage(realEstate: realEstate);
                        }));
                      },
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(realEstate['images'][0]),
                      ),
                      title: Text(
                        realEstate['title'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${realEstate['price']} \$',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 60,
                        child: Row(
                          children: [
                            Text(realEstate['rating']),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFE0A410),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // Slidable Children
  List<SlidableAction> slidableChildren = [
    SlidableAction(
      onPressed: (context) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('هل انت متأكد من الحذف ؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("لا"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "تم الحذف بنجاح",
                      ),
                    ),
                  );
                },
                child: const Text("نعم"),
              )
            ],
          ),
        );
      },
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'حذف',
    )
  ];
}
