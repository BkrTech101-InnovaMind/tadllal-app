import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/config/login_info.dart';
import 'package:tadllal/widgets/save_dialog.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordPopUpState();
}

class _ChangePasswordPopUpState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool showSuccessPopup = false;
  String oldPassword = jsonDecode(LoginInfo().login_info!)[PASSWORD];

  Map<String, dynamic> passwordValues = {};

  void changePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    passwordValues = {
      "current_password": currentPassword,
      "new_password": newPassword,
      "new_password_confirmation": confirmPassword,
    };

    if (newPassword == currentPassword) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("كلمة السر الجديدة تتطابق مع كلمة السر القديمه"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("حسناً")),
          ],
        ),
      );
    } else if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("كلمة السر الجديدة لا تطابق تاكيد كلمة السر"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("حسناً")),
          ],
        ),
      );
    } else {
      _onChange();
    }
  }

  Future<void> _onChange() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SaveDialog(
        formValue: [
          {"path": "/profile/change-password", "myData": passwordValues}
        ],
        onUrlChanged: (data) {
          LoginInfo.set_USERNAME_PASSWORD(
              user_name: jsonDecode(LoginInfo().login_info!)[USERNAME],
              password: _newPasswordController.text.trim());

          Navigator.of(context2).pop();

          setState(() {
            showSuccessPopup = true;
          });
        },
      ),
    );
  }

  bool _isValidPassword(String value) {
    RegExp passwordPattern =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]+$');
    return passwordPattern.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        showSuccessPopup
            ? '✅ تم تغيير كلمة المرور بنجاح'
            : 'لا تنسى ان تجعلها قوية يصعب تخمينها ',
      ),
      content: SingleChildScrollView(
        child: showSuccessPopup
            ? const Text('لا تنسى حفضها في مكان امن حتى لا تضيعها مرةَ اخرى')
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (value) =>
                            value == null || value.isEmpty ? "" : null,
                        controller: _currentPasswordController,
                        decoration: const InputDecoration(
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          labelText: "كلمة السر الحالية",
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
                        keyboardType: TextInputType.name,
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
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          labelText: 'كلمة المرور الجديدة',
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
                        controller: _newPasswordController,
                        decoration: const InputDecoration(
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          labelText: 'تأكيد كلمة المرور الجديدة',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      actions: [
        if (!showSuccessPopup)
          TextButton(
            onPressed: () {
              changePassword();
            },
            child: const Text('تأكيد'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(!showSuccessPopup ? 'إلغاء' : "حسناً"),
        ),
      ],
    );
  }
}
