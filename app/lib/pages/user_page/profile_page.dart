import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/components/change_password_pop_up.dart';
import 'package:tadllal/config/config.dart';
import 'package:tadllal/model/api_molels/user.dart';
import 'package:tadllal/pages/add_user_page/add_user_page.dart';
import 'package:tadllal/pages/change_user_preferences_page/change_user_preferences_page.dart';
import 'package:tadllal/pages/user_page/profile_editor_page/profile_editor_page.dart';
import 'package:tadllal/services/helpers.dart';
import 'package:tadllal/widgets/logout_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User();

  File? selectedImage;
  String userImage = "";

  @override
  void initState() {
    // TODO: implement initState
    user = Config().user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            buildUserAvatar(),
            buildUserInfo(),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  //User Avatar widget
  Widget buildUserAvatar() {
    if (user.attributes!.avatar == null) {
      return const CircleAvatar(
        radius: 100,
        backgroundColor: Color(0xFFF5F4F8),
        child: Icon(Icons.person, size: 70, color: Color(0xFFA1A5C1)),
      );
    } else {
      return Column(
        children: [
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                radius: 100,
                backgroundColor: const Color(0xFFF5F4F8),
                backgroundImage: imageProvider,
              );
            },
            imageUrl: user.attributes!.avatar!,
            placeholder: (context, url) {
              return const CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xFFF5F4F8),
                child: Icon(Icons.person, size: 70, color: Color(0xFFA1A5C1)),
              );
            },
            errorWidget: (context, url, error) => const CircleAvatar(
              radius: 100,
              backgroundColor: Color(0xFFF5F4F8),
              child: Icon(Icons.person, size: 70, color: Color(0xFFA1A5C1)),
            ),
          )
        ],
      );
    }
  }

  // User Info widget
  Widget buildUserInfo() {
    String userRole = user.attributes!.role!;
    if (user.attributes!.role == "company") {
      userRole = "شركة";
    } else if (user.attributes!.role == "marketer") {
      userRole = "مسوق";
    } else {
      userRole = "مستخدم قياسي";
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Text(
            user.attributes!.name!,
            style: const TextStyle(
              color: Color(0xFF234F68),
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              const Expanded(
                  child: Divider(
                color: Colors.black45,
                thickness: 2,
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(userRole),
              ),
              const Expanded(
                child: Divider(
                  color: Colors.black45,
                  thickness: 2,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
          color: const Color(0xFFF5F4F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: const Text("ألبريد الإلكتروني", textAlign: TextAlign.center),
            titleTextStyle: const TextStyle(
              color: Color(0xFF234F68),
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            subtitle:
                Text(user.attributes!.email!, textAlign: TextAlign.center),
            subtitleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
          color: const Color(0xFFF5F4F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: const Text("رقم الهاتف", textAlign: TextAlign.center),
            titleTextStyle: const TextStyle(
              color: Color(0xFF234F68),
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            subtitle: user.attributes!.phone != null
                ? Text(user.attributes!.phone!)
                : const Text("لا يوجد", textAlign: TextAlign.center),
            subtitleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Buttons widget
  Widget buildButtons() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1F4C6B),
              fixedSize: const Size(278, 63),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditorPage(),
                ),
              );
            },
            child: const Text(
              "تعديل الملف الشخصي",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (user.attributes!.role! == "company" ||
            user.attributes!.role! == "marketer")
          const SizedBox(height: 30),
        if (user.attributes!.role! == "company" ||
            user.attributes!.role! == "marketer")
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1F4C6B),
              fixedSize: const Size(278, 63),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserPage()),
              );
            },
            child: const Text(
              "إضافة مستخدم جديد",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF0011),
                  fixedSize: const Size(150, 63),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: const BorderSide(color: Color(0xFFFF0011), width: 3),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ChangePasswordPopUp();
                    },
                  );
                },
                child: const Text(
                  "تعديل كلمة المرور",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF0011),
                  fixedSize: const Size(150, 63),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: const BorderSide(color: Color(0xFFFF0011), width: 3),
                ),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context2) => LogoutDialog(
                      onLogOutPressed: () {
                        clearDetails();
                        Navigator.of(context2).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/authentication', (route) => false);
                      },
                    ),
                  );
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1F4C6B),
            fixedSize: const Size(278, 63),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChangeUserPreferencesPage()),
            );
          },
          child: const Text(
            "إعدادات التفضيلات",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
