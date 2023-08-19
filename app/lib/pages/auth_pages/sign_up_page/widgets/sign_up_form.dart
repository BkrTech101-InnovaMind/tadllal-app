import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/model/api_molels/sinin_sinup_request.dart';
import 'package:tadllal/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:tadllal/services/helpers.dart';
import 'package:tadllal/services/http.dart';
import 'package:tadllal/widgets/sinin_sinup_dialog.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool password = true;

  @override
  void initState() {
    _userNameController.text = "يوسف صديق";
    _phoneController.text = "zabobaker7355@gmail.com";
    _passwordController.text = "@Abo77920";
    super.initState();
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final form = {
      "name": _userNameController.text.toString(),
      "email": _phoneController.text.toString(),
      "password": _passwordController.text.toString(),
      "password_confirmation": _passwordController.text.toString(),
      "device_name": "mobile",
    };

    setBaseUrl(APP_API_URI);
    SinInSinUpRequest sinInSinUpRequest = SinInSinUpRequest.fromJson(form);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SinInSinUpDialog(
        sinInSinUpRequest: sinInSinUpRequest,
        type: SINUP_TYPE,
        onLogin: (response) async {
          await updateUserDetails(
              response: response, sinInSinUpRequest: sinInSinUpRequest);
          _navigateToSignInPage();
        },
      ),
    );
  }

  void _navigateToSignInPage() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/codeAuthenticationPage',
      (route) => false,
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
                  ? "الرجاء ادخال رقم الهاتف"
                  : null,
              controller: _phoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_iphone_outlined),
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
