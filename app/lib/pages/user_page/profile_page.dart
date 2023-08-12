import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tadllal/methods/auth_provider.dart';
import 'package:tadllal/pages/add_user_page/add_user_page.dart';
import 'package:tadllal/pages/profile_editor_page/profile_editor_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, dynamic> user = {
    "user": {
      "id": "4",
      "attributes": {
        "name": "أبوبكر صديق",
        "email": "zz78zz@zzz6z.tttt665604",
        "role": "marketer",
        "phone": null,
        "avatar": "https://i.pravatar.cc/300"
      }
    },
  };

  File? selectedImage;
  String userImage = "";

  @override
  Widget build(BuildContext context) {
    final userInfo = user['user']!['attributes'];
    String userRole = userInfo["role"];
    print(userRole);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          buildUserAvatar(userInfo),
          buildUserInfo(userInfo, userRole),
          buildButtons(userRole),
        ],
      ),
    );
  }

  //User Avatar widget
  Widget buildUserAvatar(userInfo) {
    if (userInfo["avatar"] == null) {
      return const CircleAvatar(
        radius: 100,
        backgroundColor: Color(0xFFF5F4F8),
        child: Icon(Icons.person, size: 70, color: Color(0xFFA1A5C1)),
      );
    } else {
      return Column(
        children: [
          CircleAvatar(
            radius: 100,
            backgroundColor: const Color(0xFFF5F4F8),
            backgroundImage: NetworkImage(userInfo["avatar"]),
          ),
        ],
      );
    }
  }

  // User Info widget
  Widget buildUserInfo(userInfo, userRole) {
    if (userRole == "company") {
      userRole = "شركة";
    } else if (userRole == "marketer") {
      userRole = "مسوق";
    } else {
      userRole = "مستخدم قياسي";
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Text(
            userInfo["name"],
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
            subtitle: Text(userInfo["email"], textAlign: TextAlign.center),
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
            subtitle: userInfo["phone"] != null
                ? Text(userInfo["phone"])
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
  Widget buildButtons(userRole) {
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
                  builder: (context) => const ProfileEditorPage(
                    isProfileEditor: true,
                  ),
                ),
              );
            },
            child: const Text(
              "تعديل الملف الشخصي",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (userRole == "company" || userRole == "marketer")
          const SizedBox(height: 30),
        if (userRole == "company" || userRole == "marketer")
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
                onPressed: () {},
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
                  AuthProvider().signOut();
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
