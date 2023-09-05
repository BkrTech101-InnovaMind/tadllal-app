import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/api_molels/sinin_sinup_request.dart';
import 'package:tedllal/pages/auth_pages/code_auth_page/code_auth_page.dart';
import 'package:tedllal/services/helpers.dart';
import 'package:tedllal/services/http.dart';
import 'package:tedllal/widgets/forget_password_dialog.dart';
import 'package:tedllal/widgets/sinin_sinup_dialog.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool password = true;

  @override
  void initState() {
    _emailController.text = "zabobaker7355@gmail.com";
    _passwordController.text = "@Abo77920";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setBaseUrl(APP_API_URI);
    SinInSinUpRequest sinInSinUpRequest = SinInSinUpRequest(
        email: _emailController.text.toString().trim(),
        password: _passwordController.text.toString().trim());

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SinInSinUpDialog(
        sinInSinUpRequest: sinInSinUpRequest,
        type: SININ_TYPE,
        onLogin: (response) async {
          if (response.message ==
              "Account is not activated Please check your email for activation instructions.") {
            await updateUserDetails(
                    response: response, sinInSinUpRequest: sinInSinUpRequest)
                .whenComplete(
              () => _navigateToAouthCode(),
            );
          } else {
            await updateUserDetails(
                    response: response, sinInSinUpRequest: sinInSinUpRequest)
                .whenComplete(
              () => _navigateToNavigationPage(),
            );
          }
        },
      ),
    );
  }

  void _navigateToNavigationPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/navigationPage', (route) => false);
  }

  void _navigateToAouthCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CodeAuthenticationPage(
                email: _emailController.text.trim(),
              )),
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
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || value.isEmpty
                  ? "الرجاء ادخال رقم الهاتف"
                  : null,
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Colors.black,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "البريد الإلكتروني",
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
                  setBaseUrl(APP_API_URI);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context2) => ForgetPasswordDialog(
                        email: _emailController.text.trim()),
                  );
                },
                child: const Text(
                  "هل نسيت كلمة السر؟",
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
            onPressed: () {
              handleSubmit();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "تسجيل الدخول",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset("assets/icons/arrow_left.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
