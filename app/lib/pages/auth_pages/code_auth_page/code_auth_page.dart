import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/model/api_molels/login_response.dart';
import 'package:tedllal/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:tedllal/widgets/code_authentication_dialog.dart';
import 'package:tedllal/widgets/save_dialog.dart';

class CodeAuthenticationPage extends StatefulWidget {
  final String email;
  const CodeAuthenticationPage({super.key, required this.email});

  @override
  State<CodeAuthenticationPage> createState() => _CodeAuthenticationPageState();
}

class _CodeAuthenticationPageState extends State<CodeAuthenticationPage> {
  int countdownSeconds = 120;
  Timer? _timer;
  String verificationCode = "";

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
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SaveDialog(
        formValue: [
          {
            "path": "/reSend",
            "myData": {"email": widget.email}
          }
        ],
        onUrlChanged: (data) {
          Navigator.of(context2).pop();
        },
      ),
    );
    if (_timer?.isActive == false) {
      // Reset the countdown to 30 seconds and start the timer again
      countdownSeconds = 30;
      startTimer();
    }
  }

  void onComplete(String value) {
    setState(() {
      verificationCode = value;
    });

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => CodeAuthenticationDialog(
        formValue: {
          "path": "/activate",
          "myData": {"email": widget.email, "code": verificationCode}
        },
        onUrlChanged: (data) {
          LoginResponse s = LoginResponse.fromJson(data.data);
          Config.set(
            'token',
            s.data!.token,
          );
          Config.set(
            'user',
            json.encode(s.data!.user!.toJson()),
          );
          Navigator.of(context2).pop();

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/successSignInSplashScreen', (route) => false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBackButton(context),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildIntroText(),
                    Container(
                      alignment: AlignmentDirectional.center,
                      child: VerificationCode(
                        autofocus: true,
                        length: 4,
                        keyboardType: TextInputType.number,
                        fullBorder: true,
                        fillColor: const Color(0xFFF5F4F8),
                        margin: const EdgeInsets.all(10),
                        itemSize: 60,
                        underlineColor: const Color(0xFF234F68),
                        textStyle: const TextStyle(color: Color(0xFF252B5C)),
                        underlineUnfocusedColor: Colors.transparent,
                        underlineWidth: 2,
                        onCompleted: onComplete,
                        onEditing: (value) {},
                      ),
                    ),
                    Column(
                      children: [
                        buildTimer(countdownSeconds),
                        const SizedBox(height: 10),
                        buildResendButton(onResendPressed: resendCode),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// Back Button widget
  Widget buildBackButton(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
            (Route<dynamic> route) => false,
          );
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
        Text("الذي أرسلناه إلى ${widget.email}")
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
}
