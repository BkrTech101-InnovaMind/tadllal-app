import 'package:flutter/material.dart';
import 'package:tadllal/pages/home_page.dart';

void main() {
  runApp(const TadllalApp());
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
          body: SafeArea(child: HomePage()),
        ),
      ),
    );
  }
}
