import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _verifyingFormKey = GlobalKey<FormState>();
  final _newPasswordFormKey = GlobalKey<FormState>();
  final verifyingController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool showSuccessPopup = false;

  String verifyingEmailEx = 'zabobaker7355@gmail.com';
  Map<String, dynamic> passwordValues = {};

  void verifyingSubmit() {
    if (!_verifyingFormKey.currentState!.validate()) {
      return;
    }
    final String verifiedAccount = verifyingController.text;
    if (verifiedAccount == verifyingEmailEx) {
      showDialog(context: context, builder: buildNewPasswordDialog);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('رقم الهاتف او البريد الالكتروني غير صحيح'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('حسناً'),
            )
          ],
        ),
      );
    }
  }

  void newPasswordSubmit() {
    if (!_newPasswordFormKey.currentState!.validate()) {
      return;
    }
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('كلمة السر الجديدة لا تطابق تاكيدها '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('حسناً'),
            )
          ],
        ),
      );
    } else {
      passwordValues = {
        "new_password": newPassword,
        "new_password_confirmation": confirmPassword,
      };
      setState(() {
        showSuccessPopup = true;
      });
    }
  }

  bool _isValidPassword(String value) {
    RegExp passwordPattern =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]+$');
    return passwordPattern.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعادة تعيين كلمة المرور'),
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            buildText(),
            const SizedBox(height: 40),
            buildForgetPasswordForm(),
            const SizedBox(height: 40),
            buildForgetPasswordButton(),
          ],
        ),
      ),
    );
  }

  // Forget password text widget
  Widget buildText() {
    return const Text(
      'لكي تتم إعادة تعيين كلمة المرور الخاصة بك يجب ان يطابق البريد الالكتروني المدخل او رقم الهاتف الذي قمت بتسجيل الدخول من خلاله',
      style: TextStyle(fontSize: 20),
    );
  }

  // Forget password form widget
  Widget buildForgetPasswordForm() {
    return Form(
      key: _verifyingFormKey,
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
                  ? "لا يمكن ترك هذا الحقل فارغاً"
                  : null,
              controller: verifyingController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_3_outlined),
                prefixIconColor: Colors.black,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                labelText: "رقم الهاتف او البريد الالكتروني",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Forget password button widget
  Widget buildForgetPasswordButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1F4C6B),
        fixedSize: const Size(278, 63),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
      ),
      onPressed: () {
        verifyingSubmit();
      },
      child: const Text(
        "تحقق",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Forget password dialog widget
  Widget buildNewPasswordDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        showSuccessPopup ? '✅ تم تغيير كلمة المرور بنجاح' : 'تغيير كلمة المرور',
      ),
      content: showSuccessPopup
          ? const Text('لا تنسى حفضها في مكان امن حتى لا تضيعها مرةَ اخرى')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('قم بتعيين كلمة مرور جديدة'),
                const SizedBox(height: 20),
                Form(
                  key: _newPasswordFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "";
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
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور الجديدة',
                        ),
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'تأكيد كلمة المرور الجديدة',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      actions: [
        if (!showSuccessPopup)
          TextButton(
            onPressed: () => newPasswordSubmit(),
            child: const Text('تعيين كلمة مرور جديدة'),
          ),
        if (showSuccessPopup)
          TextButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const TadllalApp(),
              //     ));
            },
            child: const Text("الذهاب الى الصفحة الرئيسية"),
          ),
      ],
    );
  }
}
