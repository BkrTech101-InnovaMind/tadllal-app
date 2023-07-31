import 'package:flutter/material.dart';
import 'package:tadllal/pages/auth_pages/sign_in_page/widgets/sign_in_form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSignInIntro(context),
              const SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// Intro widget
Widget buildSignInIntro(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          Positioned(
            child: Image.asset("assets/images/login.png"),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 17, left: 10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Color(0xFFF5F4F8)),
                  backgroundColor: const Color(0xFFF5F4F8),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ),
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                text: "تسجيل ",
                style: TextStyle(fontSize: 25, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: "الدخول",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            RichText(
              text: const TextSpan(
                text: "مرحباً ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "بعودتك, لقد افتقدناك كثيراً.",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ],
        ),
      )
    ],
  );
}
