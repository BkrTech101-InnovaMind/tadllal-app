import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/config/config.dart';
import 'package:tadllal/model/api_molels/user.dart';
import 'package:tadllal/model/real_estate_type.dart';
import 'package:tadllal/pages/splash/success_sign_in_splash_screen/widgets/chose_fav_page.dart';
import 'package:tadllal/pages/splash/success_sign_in_splash_screen/widgets/complete_profile_page.dart';
import 'package:tadllal/widgets/save_dialog.dart';

class SuccessSignInSplashScreen extends StatefulWidget {
  const SuccessSignInSplashScreen({super.key});

  @override
  State<SuccessSignInSplashScreen> createState() => _SuccessSignInScreenState();
}

class _SuccessSignInScreenState extends State<SuccessSignInSplashScreen> {
  final PageController pageController = PageController();
  List<Widget> _pages = [];
  int currentIndex = 0;
  bool visibility = false;
  List<int> typeCheckedList = [];
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  FormData formData = FormData();
  File? selectedImage;
  addToCheckedList({required RealEstateType realEstateType}) {
    if (typeCheckedList.isNotEmpty &&
        realEstateType.isChecked == false &&
        typeCheckedList.contains(int.parse(realEstateType.id!))) {
      typeCheckedList
          .removeWhere((item) => item == int.parse(realEstateType.id!));
    } else {
      typeCheckedList.add(int.parse(realEstateType.id!));
    }
  }

  @override
  void initState() {
    setState(() {
      _pages = [
        ChoseFavPage(onTypePressed: (type) {
          addToCheckedList(realEstateType: type);
        }),
        CompleteProfilePage(
          onImageChanged: (file) {
            setState(() {
              selectedImage = file;
            });
          },
          emailController: emailController,
          userNameController: userNameController,
          phoneNumberController: phoneNumberController,
        ),
      ];
    });

    super.initState();
  }

  Future<void> nextButton() async {
    if (currentIndex == 1) {
      print("CheckedList :$typeCheckedList");

      if (selectedImage != null) {
        String fileName = selectedImage!.path.split('/').last;
        formData = FormData.fromMap({
          "name": userNameController.text.trim(),
          "phone": phoneNumberController.text.trim(),
          "avatar": await MultipartFile.fromFile(selectedImage!.path,
              filename: fileName),
        });
      } else {
        formData = FormData.fromMap({
          "name": userNameController.text.trim(),
          "phone": phoneNumberController.text.trim(),
        });
      }
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context2) => SaveDialog(
          formValue: [
            {
              "path": "/preferences/add",
              "myData": {"types": typeCheckedList}
            },
            {"path": "/profile/update", "myData": formData}
          ],
          onUrlChanged: (data) {
            for (var element in data) {
              // if(element.data.)
              print(element);
            }

            User user = User.fromJson(data[1].data["data"]["user"]);
            Config.set(
              'user',
              json.encode(user),
            );
            Navigator.of(context2).pop();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/navigationPage', (route) => false);
          },
        ),
      );
    } else if (currentIndex < _pages.length - 1) {
      setState(() {
        currentIndex++;
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void backButton() {
    if (currentIndex < _pages.length + 1) {
      setState(() {
        currentIndex--;
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void onPageChange(int index) {
    setState(
      () {
        currentIndex = index;
        pageController.animateToPage(
          index,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // SignIn Splash Builder
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildSkipButton(),
                const SizedBox(height: 30),
                buildPageViewer(),
                const SizedBox(height: 30),
                buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Skip & Back Button widget
  Widget buildSkipButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/navigationPage', (route) => false);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Color(0xFFF5F4F8)),
            backgroundColor: const Color(0xFFF5F4F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const Text("تخطِ"),
        ),
        Visibility(
          visible: currentIndex == 1,
          child: Container(
            alignment: AlignmentDirectional.topEnd,
            child: OutlinedButton(
              onPressed: () {
                backButton();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Color(0xFFF5F4F8)),
                backgroundColor: const Color(0xFFF5F4F8),
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  // Page Viewer widget
  Widget buildPageViewer() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        itemCount: _pages.length,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          onPageChange(index);
        },
        itemBuilder: (_, index) {
          return _pages[index];
        },
      ),
    );
  }

  // Next Button widget
  Widget buildNextButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF8BC83F),
        foregroundColor: Colors.white,
        fixedSize: const Size(278, 63),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: () {
        nextButton();
      },
      child: const Text(
        "التالي",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
