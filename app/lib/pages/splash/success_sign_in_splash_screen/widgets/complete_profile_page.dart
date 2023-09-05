import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/services/helpers.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage(
      {super.key,
      required this.onImageChanged,
      required this.userNameController,
      required this.emailController,
      required this.phoneNumberController});

  final Function(File) onImageChanged;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? selectedImage;
  String userImage = "";

  void _pickImage(ImageSource source) async {
    if (await checkPermission(source: source) == true) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
          widget.onImageChanged(selectedImage!);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(
            source == ImageSource.camera
                ? "تم رفض الوصول الى الكاميرا"
                : "تم رفض الوصول الى معرض الصور",
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.userNameController.text = Config().user.attributes!.name!;
    widget.emailController.text = Config().user.attributes!.email!;
    widget.phoneNumberController.text = Config().user.attributes!.phone!;
    userImage = Config().user.attributes!.avatar ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        buildTexts(),
        buildCompleteProfileForm(),
      ],
    );
  }

  // Text widget
  Widget buildTexts() {
    return const Column(
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
    );
  }

  // Complete Profile Form widget
  Widget buildCompleteProfileForm() {
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
                controller: widget.userNameController,
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
                color: const Color(0xFF234F68),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
                controller: widget.emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  prefixIconColor: Colors.white,
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 25),
                  labelStyle: TextStyle(color: Colors.white),
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
                controller: widget.phoneNumberController,
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

  // Profile Image widget
  Widget buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: selectedImage == null
              ? const AssetImage(
                  "assets/images/avatar_placeholder.png",
                )
              : FileImage(File(selectedImage!.path)) as ImageProvider<Object>,
        ),
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
            ))
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
}
