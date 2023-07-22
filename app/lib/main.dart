import 'package:flutter/material.dart';
import 'package:tadllal/home_page.dart';

void main() {
  runApp(const TadllalApp());
}

class TadllalApp extends StatelessWidget {
  const TadllalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: HomePage()),
      ),
    );
  }
}
