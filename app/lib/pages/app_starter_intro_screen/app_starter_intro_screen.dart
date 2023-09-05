import 'package:flutter/material.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/pages/app_starter_intro_screen/widgets/on_boarding_splash.dart';
import 'package:tedllal/pages/auth_pages/auth_pages.dart';

class AppStarterIntroScreen extends StatefulWidget {
  const AppStarterIntroScreen({super.key});

  @override
  State<AppStarterIntroScreen> createState() => _AppStarterIntroScreenState();
}

class _AppStarterIntroScreenState extends State<AppStarterIntroScreen> {
  final PageController pageController = PageController();
  List<Widget> _screens = [];
  int currentIndex = 0;
  bool visibility = false;

  bool isAnimating = false;

  void nextButton() {
    if (!isAnimating && currentIndex < 2) {
      if (currentIndex < _screens.length - 1) {
        setState(() {
          isAnimating = true;
          currentIndex++;
          pageController
              .animateToPage(
            currentIndex,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          )
              .then((value) {
            setState(() {
              isAnimating = false;
            });
          });
          visibility = true;
        });
      }
    } else if (!isAnimating) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const AuthenticationPage();
      }));
    }
  }

  void backButton() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        visibility = currentIndex != 0;
      });
    }
  }

  @override
  void initState() {
    Config.set("starterHasShown", true);
    setState(() {
      _screens = [
        const OnBoardingSplash(
          title: "اكتشف أفضل مكان يقدم أفضل جودة وعروض حصرية",
          subTitle:
              "نقدم عروضًا حصرية في عالم العقارات, بعيدًا عن السماسرة والوسطاء",
          imagePath: 'assets/images/tour_1.png',
        ),
        const OnBoardingSplash(
          title: "بيع أو اشترِ عقارك فقط بضغطة زر",
          subTitle:
              "بِع واشترِ أي عقار ترغب به بضغطة زر, مع تدلل ما عليك إلا أنك تدّلل",
          imagePath: 'assets/images/tour_2.png',
        ),
        const OnBoardingSplash(
          title: "اكتشف الخيار الأمثل لمنزلك المستقبلي",
          subTitle:
              "خيارات متعددة تناسب ميزانيتك, اكتشف الخيار الأمثل لمنزلك المستقبلي",
          imagePath: 'assets/images/tour_3.png',
        ),
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                buildSkipAndLogoSection(),
                buildSplashScreens(),
              ],
            ),
            buildNextAndBackButton(),
          ],
        ),
      ),
    );
  }

  // Skip Button & Logo Icon
  Widget buildSkipAndLogoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthenticationPage(),
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
          Image.asset("assets/images/no-text-logo.png", width: 35),
        ],
      ),
    );
  }

  // Splash Screens
  Widget buildSplashScreens() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        itemCount: _screens.length,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          currentIndex = index;
        },
        itemBuilder: (_, index) {
          return _screens[index];
        },
        scrollBehavior: const MaterialScrollBehavior(),
      ),
    );
  }

  // Next & Back Button
  Widget buildNextAndBackButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 50, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => nextButton(),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF8BC83F),
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 63),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Text(
                currentIndex < 2 ? "التالي" : "ابدأ",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Visibility(
              visible: visibility,
              child: OutlinedButton(
                onPressed: () => backButton(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(22),
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Color(0xFFF5F4F8)),
                  backgroundColor: const Color(0xFFF5F4F8),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.arrow_forward_rounded, size: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
