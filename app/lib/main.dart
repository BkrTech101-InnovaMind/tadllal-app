import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tadllal/methods/api_provider.dart';
import 'package:tadllal/pages/auth_pages/auth_pages.dart';
import 'package:tadllal/pages/navigation_page/navigation_page.dart';
import 'package:tadllal/pages/splash/splash_screen.dart';
import 'package:tadllal/pages/splash/success_sign_in_splash_screen/success_sign_in_splash_screen.dart';
import 'package:tadllal/services/helpers.dart';
import 'package:tadllal/services/http.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDb();
  await initApiConfig();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "YE"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      title: 'Tadllal App',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const SplashScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/navigationPage': (context) => const NavigationPage(),
        '/authentication': (context) => const AuthenticationPage(),
        '/successSignInSplashScreen': (context) =>
            const SuccessSignInSplashScreen(),
      },
    ),
  ));
}
