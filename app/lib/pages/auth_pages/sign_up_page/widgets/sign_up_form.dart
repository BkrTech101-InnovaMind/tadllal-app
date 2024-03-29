import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/api_models/signin_signup_request.dart';
import 'package:tedllal/pages/auth_pages/code_auth_page/code_auth_page.dart';
import 'package:tedllal/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:tedllal/services/helpers.dart';
import 'package:tedllal/services/http.dart';
import 'package:tedllal/widgets/signin_signup_dialog.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool password = true;

  @override
  void initState() {
    _userNameController.text = "أبوبكر صديق محمد مهدي";
    _emailController.text = "zabobaker7355@gmail.com";
    _passwordController.text = "@Abo77920";
    super.initState();
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final form = {
      "name": _userNameController.text.toString(),
      "email": _emailController.text.toString(),
      "password": _passwordController.text.toString(),
      "password_confirmation": _passwordController.text.toString(),
      "device_name": "mobile",
    };

    await setBaseUrl(appApiUri);
    _showTheDialog(form);
  }

  void _showTheDialog(form) {
    SignInSignUpRequest signInSignUpRequest =
        SignInSignUpRequest.fromJson(form);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SignInSignUpDialog(
        signInSignUpRequest: signInSignUpRequest,
        type: signUpType,
        onLogin: (response) async {
          await updateUserDetails(
              response: response, signInSignUpRequest: signInSignUpRequest);
          _navigateToSignInPage(response);
        },
      ),
    );
  }

  void _navigateToSignInPage(response) {
    log("SIN UP USER DATA=>${response.toJson()}");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => CodeAuthenticationPage(
                email: _emailController.text.trim(),
              )),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              keyboardType: TextInputType.name,
              validator: (value) => value == null || value.isEmpty
                  ? "ألرجاء ادخل اسمك الثنائي على الاقل"
                  : null,
              controller: _userNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_3_outlined),
                prefixIconColor: Colors.black,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "ألاسم الكامل",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || value.isEmpty
                  ? "الرجاء ادخال البريد الإلكتروني"
                  : null,
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Colors.black,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "رقم الهاتف",
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء ادخال كلمة السر";
                } else if (value.length < 6) {
                  return "كلمة السر يجب أن لا تقل عن 8 أحرف";
                } else if (value.length > 24) {
                  return "كلمة السر يجب أن لا تزيد عن 24 حرف";
                } else if (!_isValidPassword(value)) {
                  return "كلمة السر يجب أن تحتوي على ألاقل حرفاً كبيراً وحرفاً صغيراً ورقماً وحرفاً خاص";
                } else {
                  return null;
                }
              },
              obscureText: password,
              controller: _passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined),
                prefixIconColor: Colors.black,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "كلمة السر",
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    password = !password;
                  });
                },
                child: const Text(
                  "إظهار كلمة السر",
                  style: TextStyle(
                    color: Color(0xFF1F4C6B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignInPage(),
                    ),
                  );
                },
                child: const Text(
                  "لديك حساب بالفعل؟",
                  style: TextStyle(
                    color: Color(0xFF1F4C6B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC83F),
              foregroundColor: Colors.white,
              fixedSize: const Size(278, 63),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () => handleSubmit(),
            child: const Text(
              "إنشاء حساب",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// password Validation Pattern
bool _isValidPassword(String value) {
  RegExp passwordPattern =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]+$');
  return passwordPattern.hasMatch(value);
}
