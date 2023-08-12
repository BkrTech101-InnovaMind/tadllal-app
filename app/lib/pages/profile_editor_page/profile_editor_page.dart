import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditorPage extends StatefulWidget {
  final bool isProfileEditor;
  const ProfileEditorPage({required this.isProfileEditor, super.key});

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditorPage> {
  bool isProfileEditor = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File? selectedImage;
  String? userImage;

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
        userImage = selectedImage!.path;
      });
    }
  }

  final Map<String, dynamic> user = {
    "user": {
      "id": "4",
      "attributes": {
        "name": "أبوبكر صديق",
        "email": "zz78zz@zzz6z.tttt665604",
        "role": "user",
        "phone": "779 207 445",
        "avatar": "https://i.pravatar.cc/300"
      }
    },
  };

  Map<String, dynamic> originalUserData = {};

  @override
  void initState() {
    final userInfo = user['user']!['attributes'];
    userNameController.text = userInfo['name'];
    emailController.text = userInfo['email'];
    if (userInfo['phone'] != null) {
      phoneNumberController.text = userInfo['phone'];
    }
    userImage = userInfo['avatar'];
    isProfileEditor = widget.isProfileEditor;
    originalUserData = {
      "name": userNameController.text,
      "email": emailController.text,
      "phone": phoneNumberController.text,
      "avatar": userImage,
    };
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    selectedImage = null;
    userImage = "";
    super.dispose();
  }

  void handleSubmit() {
    final editedForm = {
      "name": userNameController.text,
      "email": emailController.text,
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
      print("Changed fields: $changedFields");
    } else {
      print("No changes to submit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isProfileEditor
          ? AppBar(
              title: const Text("تعديل الملف الشخصي"),
              backgroundColor: const Color(0xFF194706),
            )
          : null,
      body: Container(
        margin: isProfileEditor
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
            : null,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            buildTexts(isProfileEditor),
            buildProfileForm(isProfileEditor),
            buildSubmitButton(isProfileEditor),
          ],
        ),
      ),
    );
  }

  // Text widget
  Widget buildTexts(isProfileEditor) {
    return !isProfileEditor
        ? const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 260,
                child: Text.rich(
                  TextSpan(
                    text: "أضف معلوماتك واجعل ",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "حسابك ",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      TextSpan(text: "مكتملاً")
                    ],
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: "يمكنك تعديل هذا لاحقاً في ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: "إعدادات الحساب الشخصي",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          )
        : Container();
  }

  // Profile Form widget
  Widget buildProfileForm(isProfileEditor) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            buildProfileImage(),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.name,
                validator: (value) => value == null || value.isEmpty
                    ? "ألرجاء ادخل اسمك الثنائي على الاقل"
                    : null,
                controller: userNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_3_outlined),
                  prefixIconColor: Colors.black,
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 25),
                  hintText: "ألاسم الكامل",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: !isProfileEditor
                    ? const Color(0xFF234F68)
                    : const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                readOnly: !isProfileEditor,
                controller: emailController,
                style: TextStyle(
                    color: !isProfileEditor ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email_outlined),
                  prefixIconColor:
                      !isProfileEditor ? Colors.white : Colors.black,
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 25),
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: "عنوان البريد الالكتروني",
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone_outlined),
                  prefixIconColor: Colors.black,
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 25),
                  hintText: "رقم الهاتف",
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // User Avatar widget
  Widget buildUserAvatar() {
    if (selectedImage == null) {
      if (userImage == null) {
        return const CircleAvatar(
          radius: 60,
          backgroundColor: Color(0xFFF5F4F8),
          child: Icon(Icons.person, size: 70, color: Color(0xFFA1A5C1)),
        );
      } else {
        return Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFFF5F4F8),
              backgroundImage: NetworkImage(userImage!),
            ),
          ],
        );
      }
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage: FileImage(File(selectedImage!.path)),
      );
    }
  }

  // Profile Image widget
  Widget buildProfileImage() {
    return Stack(
      children: [
        buildUserAvatar(),
        Positioned(
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
                size: 20,
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

  // Profile Editor Submit Button widget
  Widget buildSubmitButton(isProfileEditor) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: isProfileEditor
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1F4C6B),
                fixedSize: const Size(278, 63),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
              ),
              onPressed: () {
                handleSubmit();
              },
              child: const Text(
                "تعديل",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
