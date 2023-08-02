import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tadllal/pages/auth_pages/auth_pages.dart';

void main() {
  runApp(const ProviderScope(child: TadllalApp()));
}

class TadllalApp extends StatelessWidget {
  const TadllalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(child: AuthenticationPage()),
        ),
      ),
    );
  }
}
