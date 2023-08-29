import 'dart:io';

import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/services/api/dio_api.dart';

enum ForgetPasswordStatus{
  emailVerification,
  resetCodeVerification,
  resetPassword,
  done
}

class ForgetPasswordDialog extends StatefulWidget {
  const ForgetPasswordDialog({super.key, this.email});

  final String? email;

  @override
  State<ForgetPasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  DioApi dioApi = DioApi();
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _resetCodeController = TextEditingController();
  Future<Response> _data =
      Future(() => Response(requestOptions: RequestOptions()));

  final String _emailKeyName = "email";
  final String _resetCodeKeyName = "reset_code";
  final String _newPasswordKeyName = "new_password";
  final String _newPasswordConfirmationKeyName = "new_password_confirmation";
  late bool _passwordIsObscure = true;
  late bool _passwordConfirmationIsObscure = true;
  late bool isWaiting = false;

  late ForgetPasswordStatus forgetPasswordStatus =
      ForgetPasswordStatus.emailVerification;

  @override
  void initState() {
    _emailController.text = widget.email ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      contentPadding: EdgeInsets.zero,
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding:
              const EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xff103c5b),
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("تغيير كلمة المرور",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color(0xfff48923),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const Divider(
                    height: 10,
                    color: Colors.white,
                    thickness: 1.5,
                    indent: 1,
                    endIndent: 1),
                const SizedBox(height: 11.0),
                buildDescription(),
                const SizedBox(height: 15.0),
                FutureBuilder<Response>(
                    future: _data,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return waitingBody();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          return FormBuilder(
                            key: _formKey,
                            // initialValue: {_emailKeyName: widget.email},
                            child: formWidget(),
                          );
                        } else {
                          return Column(
                            children: [
                              const FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                    "حدث خطاء اثناء الحفظ يرجى إعادة المحاولة",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        color: Color(0xfff48923),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12)),
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    height: 30.0,
                                    minWidth: 50.0,
                                    color: const Color(0xFFBD6611),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    splashColor: Colors.redAccent,
                                    child: const Text(
                                      'الغاء',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  MaterialButton(
                                    height: 30.0,
                                    minWidth: 50.0,
                                    color: const Color(0xFFBD6611),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      _getData();
                                    },
                                    splashColor: Colors.redAccent,
                                    child: const Text(
                                      'إعادة المحاولة',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      } else {
                        return const FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                              "حدث خطاء اثناء الحفظ يرجى إعادة المحاولة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Color(0xfff48923),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                        );
                      }
                    }),
                const SizedBox(height: 15.0),
                buildButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget waitingBody() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: const ColorfulCircularProgressIndicator(
            colors: [
              Color(0xFF194706),
              Colors.white,
              Color(0xFF8BC83F),
              Colors.white,
            ],
            strokeWidth: 2,
            indicatorHeight: 20,
            indicatorWidth: 20,
          ),
        ),
        const Expanded(
          child: Text("جاري حفظ البيانات يرجى الانتظار",
              textAlign: TextAlign.center,
              softWrap: true,
              // overflow: TextOverflow.fade,
              style: TextStyle(
                  fontFamily: "Cairo",
                  color: Color(0xfff48923),
                  fontWeight: FontWeight.normal,
                  fontSize: 12)),
        ),
      ],
    );
  }

  Widget buildDescription() {
    switch (forgetPasswordStatus) {
      case ForgetPasswordStatus.emailVerification:
        {
          return Visibility(
            visible: !isWaiting,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xfff48923),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                      "لكي تتم إعادة تعيين كلمة المرور الخاصة بك يجب ان يطابق البريد الالكتروني المدخل او رقم الهاتف الذي قمت بتسجيل الدخول من خلاله",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      // overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: "Cairo",
                          color: Color(0xfff48923),
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ),
              ],
            ),
          );
        }
      case ForgetPasswordStatus.resetCodeVerification:
        {
          return Visibility(
            visible: !isWaiting,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xfff48923),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                      "ادخل كود اعادة تعيين كلمة المرور الذي تم إرسالة الى البريد الالكتروني",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      // overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: "Cairo",
                          color: Color(0xfff48923),
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ),
              ],
            ),
          );
        }
      case ForgetPasswordStatus.resetPassword:
        {
          return Visibility(
            visible: !isWaiting,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xfff48923),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                      "تهانينا انت على وشك اتمام عملية تغيير كلمة المرور",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      // overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: "Cairo",
                          color: Color(0xfff48923),
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ),
              ],
            ),
          );
        }

      case ForgetPasswordStatus.done:
        {
          return Visibility(
            visible: !isWaiting,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.done_outline_outlined,
                  color: Color(0xfff48923),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text("تهانينا تم تغيير كلمة المرور الخاصة بك",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      // overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: "Cairo",
                          color: Color(0xfff48923),
                          fontWeight: FontWeight.normal,
                          fontSize: 15)),
                ),
              ],
            ),
          );
        }
    }
  }

  Widget formWidget() {
    switch (forgetPasswordStatus) {
      case ForgetPasswordStatus.emailVerification:
        {
          return FormBuilderTextField(
            name: _emailKeyName,
            controller: _emailController,
            textAlign: TextAlign.start,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
            maxLines: null,
            keyboardType: TextInputType.emailAddress,
            style: lightDetailsTextFieldTheme,
            decoration: InputDecoration(
              labelText: 'البريد الالكتروني',
              labelStyle: lightDetailsLabelTextFieldTheme,
              // floatingLabelAlignment: FloatingLabelAlignment.center,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              fillColor: const Color(0xff375c77),
              //<-- SEE HERE
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xff707070)),
                //<-- SEE HERE
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: const OutlineInputBorder(
                  gapPadding: 1,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Color(0xfff48923))),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Color(0xff235175)),
              ),
            ),
          );
        }
      case ForgetPasswordStatus.resetCodeVerification:
        {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FormBuilderTextField(
                name: _emailKeyName,
                controller: _emailController,
                textAlign: TextAlign.start,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
                keyboardType: TextInputType.emailAddress,
                enabled: false,
                style: lightDetailsTextFieldTheme,
                decoration: InputDecoration(
                  labelText: 'البريد الالكتروني',
                  labelStyle: lightDetailsLabelTextFieldTheme,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  fillColor: const Color(0xff375c77),
                  //<-- SEE HERE
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xff707070)),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xfff48923))),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff235175)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: _resetCodeKeyName,
                controller: _resetCodeController,
                textAlign: TextAlign.center,
                enabled: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
                style: lightDetailsTextFieldTheme,
                decoration: InputDecoration(
                  labelText: 'كود التحقق',
                  labelStyle: lightDetailsLabelTextFieldTheme,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  fillColor: const Color(0xff375c77),
                  //<-- SEE HERE
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xff707070)),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xfff48923))),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff235175)),
                  ),
                ),
              )
            ],
          );
        }
      case ForgetPasswordStatus.resetPassword:
        {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FormBuilderTextField(
                name: _emailKeyName,
                controller: _emailController,
                textAlign: TextAlign.start,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
                keyboardType: TextInputType.emailAddress,
                enabled: false,
                style: lightDetailsTextFieldTheme,
                decoration: InputDecoration(
                  labelText: 'البريد الالكتروني',
                  labelStyle: lightDetailsLabelTextFieldTheme,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  fillColor: const Color(0xff375c77),

                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xff707070)),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xfff48923))),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff235175)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: _resetCodeKeyName,
                controller: _resetCodeController,
                textAlign: TextAlign.center,
                enabled: false,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
                style: lightDetailsTextFieldTheme,
                decoration: InputDecoration(
                  labelText: 'كود التحقق',
                  labelStyle: lightDetailsLabelTextFieldTheme,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  fillColor: const Color(0xff375c77),
                  //<-- SEE HERE
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xff707070)),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xfff48923))),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff235175)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: _newPasswordKeyName,
                obscureText: _passwordIsObscure,
                textAlign: TextAlign.start,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.text,
                enabled: true,
                style: lightDetailsTextFieldTheme,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: lightDetailsLabelTextFieldTheme,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  fillColor: const Color(0xff375c77),

                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xff707070)),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xfff48923))),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff235175)),
                  ),

                  suffixIcon: IconButton(
                      icon: Icon(
                          color: _passwordIsObscure
                              ? const Color(0xff103c5b)
                              : const Color(0xFFE27911),
                          _passwordIsObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordIsObscure = !_passwordIsObscure;
                        });
                      }),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: _newPasswordConfirmationKeyName,
                obscureText: _passwordConfirmationIsObscure,
                textAlign: TextAlign.start,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.text,
                enabled: true,
                style: lightDetailsTextFieldTheme,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: lightDetailsLabelTextFieldTheme,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  fillColor: const Color(0xff375c77),
                  //<-- SEE HERE
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xff707070)),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xfff48923))),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xff235175)),
                  ),

                  suffixIcon: IconButton(
                      icon: Icon(
                          color: _passwordConfirmationIsObscure
                              ? const Color(0xff103c5b)
                              : const Color(0xFFE27911),
                          _passwordConfirmationIsObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordConfirmationIsObscure =
                              !_passwordConfirmationIsObscure;
                        });
                      }),
                ),
              ),
            ],
          );
        }
      case ForgetPasswordStatus.done:
        {
          return Container();
        }
    }
  }

  Widget buildButtons() {
    switch (forgetPasswordStatus) {
      case ForgetPasswordStatus.emailVerification:
        {
          return Visibility(
            visible: !isWaiting,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'الغاء',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    _getData();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'التالي',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }
      case ForgetPasswordStatus.resetCodeVerification:
        {
          return Visibility(
            visible: !isWaiting,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'الغاء',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    _getData();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'التالي',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }
      case ForgetPasswordStatus.resetPassword:
        {
          return Visibility(
            visible: !isWaiting,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'الغاء',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    _getData();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'تغيير',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

      case ForgetPasswordStatus.done:
        {
          return Visibility(
              visible: !isWaiting,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: const Color(0xFFBD6611),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.redAccent,
                  child: const Text(
                    'اغلاق',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ));
        }
    }
  }

  void _getData() {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        switch (forgetPasswordStatus) {
          case ForgetPasswordStatus.emailVerification:
            {
              isWaiting = true;
              _data = dioApi.postForgetPassword("/forgotPassword",
                  myData: {_emailKeyName: _emailController.text.trim()});
              _data.then((value) {
                if (value.statusCode == HttpStatus.ok) {
                  forgetPasswordStatus =
                      ForgetPasswordStatus.resetCodeVerification;
                }
              }).whenComplete(() {
                setState(() {
                  isWaiting = false;
                });
              });
              break;
            }
          case ForgetPasswordStatus.resetCodeVerification:
            {
              isWaiting = true;
              _data = dioApi.post("/verifyResetCode", myData: {
                _emailKeyName: _emailController.text.trim(),
                _resetCodeKeyName: _resetCodeController.text.trim()
              });
              _data.then((value) {
                if (value.statusCode == HttpStatus.ok) {
                  forgetPasswordStatus = ForgetPasswordStatus.resetPassword;
                }
              }).whenComplete(() {
                setState(() {
                  isWaiting = false;
                });
              });
              break;
            }
          case ForgetPasswordStatus.resetPassword:
            {
              isWaiting = true;
              Map<String, dynamic> mainFormValue = _formKey.currentState!.value;
              print(mainFormValue);
              _data = dioApi.post("/resetPassword", myData: mainFormValue);
              _data.then((value) {
                if (value.statusCode == HttpStatus.ok) {
                  forgetPasswordStatus = ForgetPasswordStatus.done;
                }
              }).whenComplete(() {
                setState(() {
                  isWaiting = false;
                });
              });

              break;
            }
          case ForgetPasswordStatus.done:
            {
              break;
            }
        }
      });
    }
  }
}
