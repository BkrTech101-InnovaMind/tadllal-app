import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/config/config.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/pages/app_starter_intro_screen/app_starter_intro_screen.dart';
import 'package:tadllal/pages/auth_pages/auth_pages.dart';
import 'package:tadllal/pages/navigation_page/navigation_page.dart';

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
    if (isLoggedIn == true && starterHasShown == true) {
      // return AppStarterIntroScreen();
      return const NavigationPage();
    } else if (isLoggedIn == false && starterHasShown == true) {
      return const AuthenticationPage();
    } else {
      return const AppStarterIntroScreen();
    }
  }
}
