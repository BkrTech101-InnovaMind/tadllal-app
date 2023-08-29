import 'package:flutter/material.dart';

const String APP_VERSION_KEY_NAME = "VERSION";
const int APP_VERSION_VALUE = 1;

const String SININ_TYPE = "SIN_IN";
const String SINUP_TYPE = "SIN_UP";
const String LOGIN_INFO_KEY_NAME = "USERNAME_PASSWORD";
const String USERNAME = "user_name";
const String PASSWORD = "password";

// API endpoint URL
const String APP_API_URI = "https://tadllal.alqatta.com";
// const String APP_API_URI = "http://192.168.1.251";
// const String APP_API_URI="http://192.168.0.221";

//Hero Tags

/*Splash Screen With Login Screen Hero */
String splashWithLoginHero = "splash_with_login_Hero";

const String LOADING_DATA_FROM_SERVER = "جاري جلب البيانات ...";
const String NO_DATA = "لاتوجد بيانات";
const String ERROR_WHILE_GET_DATA = "حدث خطأ اثناء جلب البيانات";
const String SESSION_ENDED = "انتهت الجلسة يجب اعادة تسجيل الدخول";
const String DATE_TIME_PICKER_CONFIRM = "تأكيد";
const String WORK_ASSIGNMENT_SELECT_TASK_DATE = "اختر تاريخ المهمة";

class Consts {
  Consts._();

  static const double padding = 11.0;
  static const double avatarRadius = 55.0;
}

const TextStyle lightDetailsTextFieldTheme = TextStyle(
    fontFamily: "Cairo",
    fontSize: 11,
    color: Color(0xFF8BC83F),
    fontWeight: FontWeight.bold);

const TextStyle lightDetailsLabelTextFieldTheme = TextStyle(
    fontFamily: "Cairo",
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1F4C6B),
    decoration: TextDecoration.underline);
