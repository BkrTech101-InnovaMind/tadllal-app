import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildIntroImages(),
      ],
    );
  }
}

// Intro images
Widget buildIntroImages() {
  final images = [
    "assets/images/shape.png",
    "assets/images/shape2.png",
    "assets/images/shape3.png",
    "assets/images/shape4.png",
  ];
  return GridView.builder(
    shrinkWrap: true,
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: images.length,
    itemBuilder: ((context, index) {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(images[index]),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }),
  );
}
