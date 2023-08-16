import 'package:flutter/material.dart';

class OnBoardingSplash extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imagePath;
  const OnBoardingSplash({
    required this.title,
    required this.subTitle,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTexts(),
        buildImage(),
      ],
    );
  }

  // Texts
  Widget buildTexts() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: Text(
              title.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 250,
            child: Text(
              subTitle.toString(),
              style: const TextStyle(fontSize: 15, height: 1),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // Image
  Widget buildImage() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath.toString()),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
