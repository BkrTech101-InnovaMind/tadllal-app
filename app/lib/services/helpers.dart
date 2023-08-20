import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tadllal/config/config.dart';
import 'package:tadllal/config/login_info.dart';
import 'package:tadllal/model/api_molels/login_response.dart';
import 'package:tadllal/model/api_molels/sinin_sinup_request.dart';
import 'package:tadllal/services/dio_helper.dart';
import 'package:tadllal/services/storage_service.dart';
import 'package:tadllal/widgets/logout_dialog.dart';

getDownloadPath() async {
  if (Platform.isAndroid) {
    return '/storage/emulated/0/Download/';
  } else if (Platform.isIOS) {
    final Directory downloadsDirectory =
        await getApplicationDocumentsDirectory();
    return downloadsDirectory.path;
  }
}

String toTitleCase(String str) {
  return str
      .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
              "${m[0]![0].toUpperCase()}${m[0]!.substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-)+'), ' ');
}

DateTime parseDate(val) {
  if (val == null) {
    return DateTime.now();
  } else if (val == "Today") {
    return DateTime.now();
  } else {
    return DateTime.parse(val);
  }
}

String getInitials(String txt) {
  List<String> names = txt.split(" ");
  String initials = "";
  int numWords = 2;

  if (names.length < numWords) {
    numWords = names.length;
  }
  for (var i = 0; i < numWords; i++) {
    initials += names[i] != '' ? names[i][0].toUpperCase() : "";
  }
  return initials;
}

clearLoginInfo() async {
  var cookie = await DioHelper.getCookiePath();
  if (Config().uri != null) {
    cookie.delete(
      Config().uri!,
    );
  }

  Config.set('isLoggedIn', false);
}

Future<void> updateUserDetails(
    {required LoginResponse response,
    required SinInSinUpRequest sinInSinUpRequest}) async {
  Config.set('isLoggedIn', true);

  Config.set(
    'email',
    response.data!.user!.attributes!.email,
  );
  Config.set(
    'user',
    json.encode(response.data!.user!.toJson()),
  );

  Config.set(
    'token',
    response.data!.token,
  );

  Config.set(
    'user_image',
    response.data!.user!.attributes!.avatar,
  );

  LoginInfo.set_USERNAME_PASSWORD(
      user_name: sinInSinUpRequest.email!,
      password: sinInSinUpRequest.password!);
  await DioHelper.initCookies();
}

clearDetails() {
  Config.clear();
}

initDb() async {
  StorageService storageService = StorageService();
  await storageService.initHiveStorage();

  await storageService.initHiveBox('queue');
  await storageService.initHiveBox('offline');
  await storageService.initHiveBox('config');
  await storageService.initHiveBox('login_info');
}

Widget userPlaceHolderImage() {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFDFDFDF), width: 2),
    ),
    child: Container(
      width: 50.0,
      height: 50.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/avatar_placeholder.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

on_logOut({required BuildContext context}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context2) => LogoutDialog(
      onLogOutPressed: () {
        clearLoginInfo();
        clearDetails();
        Navigator.of(context2).pop();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      },
    ),
  );
}