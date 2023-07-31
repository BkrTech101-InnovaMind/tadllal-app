import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool password = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xFFF5F4F8)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty
                  ? "الرجاء ادخال رقم الهاتف"
                  : null,
              controller: _phoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_iphone_outlined),
                hintText: "رقم الهاتف",
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Color(0xFFF5F4F8)),
            child: TextFormField(
              obscureText: password,
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
              controller: _passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined),
                hintText: "كلمة السر",
              ),
            ),
          ),
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
                  ),
                ),
              ),
            ],
          )
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
