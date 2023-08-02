import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CodeAuthenticationPage extends StatefulWidget {
  const CodeAuthenticationPage({super.key});

  @override
  State<CodeAuthenticationPage> createState() => _CodeAuthenticationPageState();
}

class _CodeAuthenticationPageState extends State<CodeAuthenticationPage> {
  int countdownSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer when the page is first loaded
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          _timer?.cancel(); // Stop the timer when it reaches 00:00
        }
      });
    });
  }

  void resendCode() {
    if (_timer?.isActive == false) {
      // Reset the countdown to 30 seconds and start the timer again
      countdownSeconds = 30;
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBackButton(context),
                buildIntroText(),
                buildTimer(countdownSeconds),
                buildResendButton(onResendPressed: resendCode)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Back Button widget
Widget buildBackButton(BuildContext context) {
  return Container(
    alignment: AlignmentDirectional.topEnd,
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
  );
}

// Intro Text widget
Widget buildIntroText() {
  String userNumber = "779-207-445";
  return Column(
    children: [
      RichText(
        text: const TextSpan(
          text: "أدخل رمز ",
          style: TextStyle(fontSize: 25, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: "التحقق",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      const Text("أدخل رمز ألتحقق ألمكون من 4 أرقام"),
      Text("الذي أرسلناه إلى $userNumber")
    ],
  );
}

// Timer widget
Widget buildTimer(int countdownSeconds) {
  String minutes = (countdownSeconds ~/ 60).toString().padLeft(2, '0');
  String seconds = (countdownSeconds % 60).toString().padLeft(2, '0');
  return Container(
    alignment: AlignmentDirectional.center,
    child: IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFFF5F4F8),
        ),
        child: Row(
          children: [
            Text("$minutes:$seconds"),
            const SizedBox(width: 6),
            const Icon(Icons.timer_sharp, size: 20),
          ],
        ),
      ),
    ),
  );
}

// Resend button widget
Widget buildResendButton({required VoidCallback onResendPressed}) {
  return Container(
    alignment: AlignmentDirectional.center,
    child: RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onResendPressed();
          },
        text: "لم يصلك رمز التحقق؟",
        style: const TextStyle(fontSize: 15, color: Colors.black),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onResendPressed();
              },
            text: "إعادة ارسال",
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ),
  );
}
