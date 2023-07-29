import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tadllal/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:tadllal/pages/auth_pages/sign_up_page/sign_up_page.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildIntro(),
        buildBody(context),
      ],
    );
  }
}

// Intro widget
Widget buildIntro() {
  final images = [
    "assets/images/shape.png",
    "assets/images/shape2.png",
    "assets/images/shape3.png",
    "assets/images/shape4.png",
  ];
  return GridView.builder(
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    ),
    itemCount: images.length,
    itemBuilder: ((context, index) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(images[index]),
            fit: BoxFit.fill,
          ),
        ),
      );
    }),
  );
}

// Body widget
Widget buildBody(BuildContext context) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: "مستعد لبدء ",
              style: TextStyle(fontSize: 25, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: "الإكتشاف",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "؟", style: TextStyle(fontSize: 35))
              ],
            ),
          ),
          buildBodyButtons(context),
        ],
      ),
    ),
  );
}

// Body Buttons widget
Widget buildBodyButtons(BuildContext context) {
  return Expanded(
    child: Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC83F),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(278, 63),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SignInPage(),
                  ),
                );
              },
              child: const Text(
                "تسجيل الدخول",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.black45)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text("أو"),
                ),
                const Expanded(child: Divider(color: Colors.black45)),
              ],
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC83F),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(278, 63),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text(
                "إنشاء حساب جديد",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            buildShareButton()
          ],
        ),
      ),
    ),
  );
}

// Share Button widget
Widget buildShareButton() {
  return GestureDetector(
    onTap: () {
      Share.share("تدلل للخدمات العقارية, دليلك السريع للعقارات في اليمن");
    },
    child: RichText(
      text: const TextSpan(
        text: "مشاركة التطبيق مع ",
        style: TextStyle(color: Colors.black, fontSize: 20),
        children: <TextSpan>[
          TextSpan(
            text: "صديق",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
