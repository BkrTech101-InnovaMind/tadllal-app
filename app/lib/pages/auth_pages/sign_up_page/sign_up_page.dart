import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/pages/auth_pages/sign_up_page/widgets/sign_up_form.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildIntroTexts(context),
                  const SizedBox(height: 40),
                  const SignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Intro texts widget
Widget buildIntroTexts(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        alignment: AlignmentDirectional.topEnd,
        margin: const EdgeInsets.only(top: 17, bottom: 40),
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
      RichText(
        text: const TextSpan(
          text: "قم بإنشاء ",
          style: TextStyle(fontSize: 25, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: "حسابك",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      const Text("أنشئ حسابك وأكتشف كل الخدمات التي نقدمها",
          style: TextStyle(color: Colors.black, fontSize: 15))
    ],
  );
}
