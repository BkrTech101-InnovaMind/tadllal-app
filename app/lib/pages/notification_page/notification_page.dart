import 'package:flutter/material.dart';

final List realEstates = [
  {
    'images': [
      'assets/images/shape.png',
      'assets/images/shape2.png',
      'assets/images/shape3.png',
      'assets/images/shape4.png',
    ],
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
  {
    'images': [
      'assets/images/shape.png',
      'assets/images/shape2.png',
      'assets/images/shape3.png',
      'assets/images/shape4.png',
    ],
    "state": "للإيجار",
    "type": "عمارة",
    "location": "بيت بوس, حي الشباب",
    "price": "235",
    "title": "فيلا واسعة للإيجار",
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
    "state": "للبيع",
    "type": "فلة",
    "location": "حدة,شارع بيروت",
    "price": "56,000",
    "title": "شقة للبيع في برج حديث وفي موقع متميز",
    "description":
        "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
    "rating": "4.8",
    "isFavorite": false
  },
];

class NotificationPage extends StatefulWidget {
  final bool isHasNotification;
  const NotificationPage({required this.isHasNotification, super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإشعارات"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.separated(
            itemCount: realEstates.length,
            separatorBuilder: (context, index) => const Divider(thickness: 2),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 15),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    realEstates[index]['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    realEstates[index]['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage(realEstates[index]['images'][0]),
                  ),
                  trailing: Container(
                    constraints: BoxConstraints.tight(const Size.square(60)),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(realEstates[index]['rating'].toString()),
                        const Icon(
                          Icons.star,
                          color: Color(0xFFE0A410),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
