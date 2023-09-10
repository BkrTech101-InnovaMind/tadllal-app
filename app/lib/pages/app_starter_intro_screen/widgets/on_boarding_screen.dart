import 'package:flutter/material.dart';
import 'package:tedllal/pages/app_starter_intro_screen/app_starter_intro_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            children: [
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF1F4C6B),
                        Color(0x001F4C6B),
                      ],
                      stops: [0.20, 1],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcATop,
                  child: const Image(
                    image: AssetImage('assets/images/splash_screen.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset('assets/images/logo.png', height: 180),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "تدلل للعقار",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC83F),
                        foregroundColor: Colors.white,
                        fixedSize: const Size(278, 63),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const AppStarterIntroScreen(),
                        ));
                      },
                      child: const Text(
                        "هيا لنبدأ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "صنع بحب",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "v.1.0.0",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
