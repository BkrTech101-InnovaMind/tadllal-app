import 'package:flutter/material.dart';
import 'package:tadllal/pages/auth_pages/sign_in_page/widgets/sign_in_form.dart';
import 'package:tadllal/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:tadllal/pages/auth_pages/widgets/share_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildSignInIntro(context),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SignInForm(),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1F4C6B),
                        fixedSize: const Size(278, 63),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        side: const BorderSide(
                            color: Color(0xFF8BC83F), width: 3),
                      ),
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "إنشاء حساب جديد",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const ShareButton()
                  ],
                ),
              ),
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
