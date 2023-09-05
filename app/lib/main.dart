import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:tedllal/methods/api_provider.dart';
import 'package:tedllal/pages/auth_pages/auth_pages.dart';
import 'package:tedllal/pages/navigation_page/navigation_page.dart';
import 'package:tedllal/pages/splash/splash_screen.dart';
import 'package:tedllal/pages/splash/success_sign_in_splash_screen/success_sign_in_splash_screen.dart';
import 'package:tedllal/services/helpers.dart';
import 'package:tedllal/services/http.dart';

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
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "YE"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      title: 'Tedllal App',
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
