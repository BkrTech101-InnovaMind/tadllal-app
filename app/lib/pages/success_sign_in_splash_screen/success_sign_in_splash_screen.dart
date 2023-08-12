import 'package:flutter/material.dart';
import 'package:tadllal/main.dart';
import 'package:tadllal/pages/profile_editor_page/profile_editor_page.dart';
import 'package:tadllal/pages/success_sign_in_splash_screen/widgets/chose_fav_page.dart';

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

  @override
  void initState() {
    setState(() {
      _pages = [
        const ChoseFavPage(),
        const ProfileEditorPage(isProfileEditor: false),
      ];
    });

    super.initState();
  }

  void nextButton() {
    if (currentIndex == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('This is your success message.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TadllalApp(),
              ),
            );
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
}
