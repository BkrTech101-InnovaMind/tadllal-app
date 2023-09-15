import 'package:flutter/material.dart';

const String appVersionKeyName = "VERSION";
const int appVersionValue = 1;

const String signInType = "SIGN_IN";
const String signUpType = "SIGN_UP";
const String logInInfoKeyName = "USERNAME_PASSWORD";
const String userName = "user_name";
const String password = "password";

// API endpoint URL
// const String appApiUri = "https://tedllal.alqatta.com";
// const String appApiUri = "http://192.168.0.169";
// const String appApiUri = "http://192.168.0.46:8080";
const String appApiUri = "http://192.168.1.103:8080";
// const String appApiUri="http://192.168.0.221";

//Hero Tags

/*Splash Screen With Login Screen Hero */
String splashWithLoginHero = "splash_with_login_Hero";

const String loadingDataFromServer = "جاري جلب البيانات ...";
const String noData = "لاتوجد بيانات";
const String errorWhileGetData = "حدث خطأ اثناء جلب البيانات";
const String sessionEnded = "انتهت الجلسة يجب اعادة تسجيل الدخول";
const String dateTimePickerConfirm = "تأكيد";
const String workAssignmentSelectTaskDate = "اختر تاريخ المهمة";

class Consist {
  Consist._();

  static const double padding = 11.0;
  static const double avatarRadius = 55.0;
}

const TextStyle lightDetailsTextFieldTheme = TextStyle(
  fontFamily: "Cairo",
  fontSize: 11,
  color: Color(0xFF234F68),
  fontWeight: FontWeight.bold,
);

const TextStyle lightDetailsLabelTextFieldTheme = TextStyle(
  fontFamily: "Cairo",
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Color(0xFF1F4C6B),
  decoration: TextDecoration.underline,
);
