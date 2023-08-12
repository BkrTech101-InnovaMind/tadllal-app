import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

class ChoseFavPage extends StatefulWidget {
  const ChoseFavPage({super.key});

  @override
  State<ChoseFavPage> createState() => _ChoseFavPageState();
}

class _ChoseFavPageState extends State<ChoseFavPage> {
  final List realEstates = [
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
    {
      "image": "assets/images/shape.png",
      "type": "فيلا",
      "isCHecked": false,
    },
  ];
  void toggleCheck(int index) {
    setState(() {
      realEstates[index]['isCHecked'] = !realEstates[index]['isCHecked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        buildTexts(),
        buildTypesGrid(),
      ],
    );
  }

  // Text widget
  Widget buildTexts() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: Text.rich(
            TextSpan(
              text: "أختر أنواع ",
              style: TextStyle(fontSize: 25, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: "العقارات ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "التي تفضلها.")
              ],
            ),
          ),
        ),
        Text.rich(
          TextSpan(
            text: "يمكنك تعديل هذا لاحقاً في ",
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: "إعدادات التفضيلات",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }

  // Types Grid Builder widget
  Widget buildTypesGrid() {
    return DynamicHeightGridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: realEstates.length,
      builder: (context, index) {
        bool isChecked = realEstates[index]['isCHecked'];
        return Card(
          color: isChecked ? const Color(0xFF1F4C6B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextButton(
            onPressed: () => {toggleCheck(index)},
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset(realEstates[index]['image']),
                    Positioned(
                      top: 10,
                      left: 15,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: isChecked ? null : Colors.white,
                          gradient: isChecked
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF1F4C6B).withAlpha(200),
                                    const Color(0xFF8BC83F)
                                  ],
                                )
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.check,
                            color: isChecked ? Colors.white : Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${realEstates[index]['type']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isChecked ? Colors.white : const Color(0xFF252B5C),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
