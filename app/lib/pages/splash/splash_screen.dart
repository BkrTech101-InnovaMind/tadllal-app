import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tedllal/config/config.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/pages/app_starter_intro_screen/widgets/on_boarding_screen.dart';
import 'package:tedllal/pages/auth_pages/auth_pages.dart';
import 'package:tedllal/pages/auth_pages/code_auth_page/code_auth_page.dart';
import 'package:tedllal/pages/navigation_page/navigation_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 200,
      backgroundColor: Colors.white,
      splash: Hero(
        tag: splashWithLoginHero,
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain),
          ),
        ),
      ),
      nextScreen: const NextPage(),
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  bool isLoggedIn = false;
  bool starterHasShown = false;

  @override
  void initState() {
    setState(() {
      isLoggedIn = Config().isLoggedIn;
      starterHasShown = Config().starterHasShown;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (starterHasShown == true && isLoggedIn == true) {
      if (Config().token.isNotEmpty) {
        return const NavigationPage();
      } else {
        return CodeAuthenticationPage(
          email: Config().user.attributes!.email!,
        );
      }
    } else {
      if (starterHasShown == true && isLoggedIn == false) {
        return const AuthenticationPage();
      } else if (starterHasShown == false &&
          (isLoggedIn == false || isLoggedIn == true)) {
        return const OnBoardingScreen();
      } else {
        return const AuthenticationPage();
      }
    }
  }
}
