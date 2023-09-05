import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/config/login_info.dart';
import 'package:tedllal/model/api_models/login_response.dart';
import 'package:tedllal/model/api_models/signin_signup_request.dart';
import 'package:tedllal/services/dio_helper.dart';
import 'package:tedllal/services/storage_service.dart';
import 'package:tedllal/widgets/logout_dialog.dart';

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
    required SignInSignUpRequest signInSignUpRequest}) async {
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

  LoginInfo.setUserNamePassword(
      userName: signInSignUpRequest.email!,
      password: signInSignUpRequest.password!);
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
  await storageService.initHiveBox('loginInfo');
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

onLogOut({required BuildContext context}) {
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

Future<bool> checkPermission({required ImageSource source}) async {
  bool permissionIsGranted = false;
  if (Platform.isAndroid || Platform.isIOS || Platform.isWindows) {
    if (source == ImageSource.camera) {
      PermissionStatus status = await Permission.camera.status;
      if (!status.isGranted) {
        PermissionStatus requestStatus = await Permission.camera.request();
        if (requestStatus == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        } else {
          permissionIsGranted = await Permission.camera.status.isGranted;
        }
      } else {
        permissionIsGranted = true;
      }
    } else if (source == ImageSource.gallery) {
      PermissionStatus status = await Permission.storage.status;

      if (!status.isGranted) {
        PermissionStatus requestStatus = await Permission.storage.request();
        if (requestStatus == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        } else {
          permissionIsGranted = await Permission.storage.status.isGranted;
        }
      } else {
        permissionIsGranted = true;
      }
    }
  } else {
    permissionIsGranted = true;
  }

  return permissionIsGranted;
}
