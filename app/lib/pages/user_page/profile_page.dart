import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/model/api_models/user.dart';
import 'package:tedllal/pages/add_user_page/add_user_page.dart';
import 'package:tedllal/pages/change_user_preferences_page/change_user_preferences_page.dart';
import 'package:tedllal/services/helpers.dart';
import 'package:tedllal/widgets/change_password_dialog.dart';
import 'package:tedllal/widgets/logout_dialog.dart';
import 'package:tedllal/widgets/save_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isEditeMode = false;
  bool isNormalUser = false;
  User user = User();

  File? selectedImage;
  String userImage = "";
  Map<String, dynamic> originalUserData = {};
  FormData formData = FormData();
  @override
  void initState() {
    setState(() {
      user = Config().user;
    });
    nameController.text = user.attributes!.name!;
    emailController.text = user.attributes!.email!;
    phoneNumberController.text = user.attributes!.phone ?? "";
    userImage = user.attributes!.avatar ?? "";

    originalUserData = {
      "name": nameController.text,
      "phone": phoneNumberController.text,
      "avatar": userImage,
    };

    if (user.attributes!.role == "user") {
      setState(() => isNormalUser = true);
    } else {
      setState(() => isNormalUser = false);
    }

    super.initState();
  }

  void handleSubmit() {
    final editedForm = {
      "name": nameController.text,
      "phone": phoneNumberController.text,
      "avatar": userImage,
    };

    final changedFields = <String, dynamic>{};
    editedForm.forEach(
      (key, value) {
        if (value != originalUserData[key]) {
          changedFields[key] = value;
        }
      },
    );
    if (changedFields.isNotEmpty) {
      _onEdit();
    }
  }

  void _showSaveDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SaveDialog(
        formValue: [
          {"path": "/profile/update", "myData": formData}
        ],
        onUrlChanged: (data) {
          User user = User.fromJson(data[0].data["data"]["user"]);
          Config.set(
            'user',
            json.encode(user),
          );
          Navigator.of(context2).pop();
          setState(() {
            isEditeMode = !isEditeMode;
          });
        },
      ),
    );
  }

  Future<void> _onEdit() async {
    if (selectedImage != null) {
      String fileName = selectedImage!.path.split('/').last;
      formData = FormData.fromMap({
        "name": nameController.text.trim(),
        "phone": phoneNumberController.text.trim(),
        "avatar": await MultipartFile.fromFile(selectedImage!.path,
            filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        "name": nameController.text.trim(),
        "phone": phoneNumberController.text.trim(),
      });
    }
    _showSaveDialog();
  }

  @override
  Widget build(BuildContext context) {
    String userRole = user.attributes!.role!;
    if (user.attributes!.role == "company") {
      userRole = "شركة";
    } else if (user.attributes!.role == "marketer") {
      userRole = "مسوق";
    } else if (user.attributes!.role == "admin") {
      userRole = "مدير";
    } else {
      userRole = "مستخدم قياسي";
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black12,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(top: 60),
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 30),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8),
                                      isCollapsed: true,
                                      enabled: isEditeMode,
                                      border: isEditeMode
                                          ? const OutlineInputBorder(
                                              borderSide: BorderSide(width: 1),
                                            )
                                          : const OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF8BC83F),
                                      fontSize: 25,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    userRole,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const Divider(
                                      thickness: 1, color: Colors.black26),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("البريد الالكتروني"),
                                            const SizedBox(height: 7),
                                            TextFormField(
                                              controller: emailController,
                                              enabled: false,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10),
                                                isCollapsed: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("رقم الهاتف"),
                                            const SizedBox(height: 7),
                                            TextFormField(
                                              controller: phoneNumberController,
                                              enabled: isEditeMode,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10),
                                                isCollapsed: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black26),
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ChangeUserPreferencesPage()),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF8BC83F),
                                            foregroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            fixedSize: const Size(1000, 40),
                                          ),
                                          child: const Text(
                                            "إعدادات التفضيل",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: const Text(
                                            "قم بإعادة ترتيب اولوياتك ومساعدتنا على ترشيح افضل الخيارت لك",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const ChangePasswordDialog();
                                              },
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.red[800],
                                            foregroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            fixedSize: const Size(1000, 40),
                                          ),
                                          child: const Text(
                                            "تغيير كلمة السر",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: const Text(
                                            "تستطيع تغيير كلمة السر من هنا عندما تحتاج إلى ذلك",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          padding: const EdgeInsets.only(bottom: 22),
                          child: Row(
                            mainAxisSize: !isNormalUser
                                ? MainAxisSize.max
                                : MainAxisSize.min,
                            children: [
                              if (!isNormalUser)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddUserPage()),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8BC83F),
                                      foregroundColor: Colors.white,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10, vertical: 10),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                    child: const Text(
                                      "إضافة مستخدم جديد",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context2) =>
                                        LogoutDialog(
                                      onLogOutPressed: () {
                                        clearDetails();
                                        Navigator.of(context2).pop();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/authentication',
                                                (route) => false);
                                      },
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.red[800],
                                  foregroundColor: Colors.white,
                                  // padding: const EdgeInsets.symmetric(
                                  //   horizontal: 10,
                                  //   vertical: 10,
                                  // ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                                child: const Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildProfileImage(),
                      Row(children: [
                        OutlinedButton(
                          onPressed: () {
                            if (isEditeMode) {
                              handleSubmit();
                            } else {
                              setState(() => isEditeMode = !isEditeMode);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            backgroundColor: const Color(0xFF8BC83F),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          child: Text(
                            isEditeMode ? "حفظ" : "تعديل الملف الشخصي",
                            style: const TextStyle(
                                fontSize: 16.2, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isEditeMode) const SizedBox(width: 10),
                        if (isEditeMode)
                          OutlinedButton(
                            onPressed: () {
                              setState(() => isEditeMode = !isEditeMode);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              backgroundColor: Colors.red[800],
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            child: const Text(
                              "إلغاء",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserAvatar() {
    if (selectedImage == null) {
      if (userImage.isEmpty) {
        return const CircleAvatar(
          radius: 35,
          backgroundColor: Color(0xFFF5F4F8),
          child: Icon(Icons.person, size: 40, color: Color(0xFFA1A5C1)),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: user.attributes!.avatar!,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFFF5F4F8),
              backgroundImage: imageProvider,
            );
          },
          placeholder: (context, url) {
            return const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFF5F4F8),
              child: Icon(Icons.person, size: 40, color: Color(0xFFA1A5C1)),
            );
          },
          errorWidget: (context, url, error) {
            return const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFF5F4F8),
              child: Icon(Icons.person, size: 40, color: Color(0xFFA1A5C1)),
            );
          },
        );
      }
    } else {
      return CircleAvatar(
        radius: 35,
        backgroundImage: FileImage(File(selectedImage!.path)),
      );
    }
  }

  // Profile Image widget
  Widget buildProfileImage() {
    return Stack(
      children: [
        buildUserAvatar(),
        Visibility(
          visible: isEditeMode,
          child: Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => buildEditingSheet()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFF1F4C6B),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Editing Sheet widget
  Widget buildEditingSheet() {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text('أختيار صورة :', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt, size: 30),
                label: const Text('Camera', style: TextStyle(fontSize: 20)),
              ),
              TextButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.browse_gallery_outlined, size: 30),
                label: const Text('Gallery', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    if (await checkPermission(source: source) == true) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
          userImage = selectedImage!.path;
        });
      }
    } else {
      _showSnackMessage(source);
    }
  }

  void _showSnackMessage(source) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          source == ImageSource.camera
              ? "تم رفض الوصول الى الكاميرا"
              : "تم رفض الوصول الى المعرض",
        ),
      ),
    );
  }
}
